/* Copyright 2021 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

/*
* @author Rikard Lindstrom <rlindsrom@google.com>
*/

#define VERSION 5
#define FLOAT_BYTE_SIZE 4

#include <ArduinoBLE.h>
#include <Arduino_LSM9DS1.h>
#include <TensorFlowLite.h>
#include <tensorflow/lite/micro/all_ops_resolver.h>
#include <tensorflow/lite/micro/micro_error_reporter.h>
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/schema/schema_generated.h>
#include <tensorflow/lite/version.h>

//==============================================================================
// Your custom data / settings
// - Editing these is not recommended
//==============================================================================

// This is the model you trained in Tiny Motion Trainer, converted to 
// a C style byte array.
#include "model.h"

// Values from Tiny Motion Trainer
#define MOTION_THRESHOLD 0.2
#define CAPTURE_DELAY 1000 // This is now in milliseconds
#define NUM_SAMPLES 50

// Array to map gesture index to a name
const char *GESTURES[] = {
    "PUNCH", "UPPERCUT"
};


//==============================================================================
// Capture variables
//==============================================================================

#define NUM_GESTURES (sizeof(GESTURES) / sizeof(GESTURES[0]))

bool isCapturing = false;

// Num samples read from the IMU sensors
// "Full" by default to start in idle
int numSamplesRead = 0;

//==============================================================================
// TensorFlow variables
//==============================================================================

// Global variables used for TensorFlow Lite (Micro)
tflite::MicroErrorReporter tflErrorReporter;

// Auto resolve all the TensorFlow Lite for MicroInterpreters ops, for reduced memory-footprint change this to only
// include the op's you need.
tflite::AllOpsResolver tflOpsResolver;

// Setup model
const tflite::Model* tflModel = nullptr;
tflite::MicroInterpreter* tflInterpreter = nullptr;
TfLiteTensor* tflInputTensor = nullptr;
TfLiteTensor* tflOutputTensor = nullptr;

// Create a static memory buffer for TensorFlow Lite for MicroInterpreters, the size may need to
// be adjusted based on the model you are using
constexpr int tensorArenaSize = 8 * 1024;
byte tensorArena[tensorArenaSize];


/************************************************************************
* Globals / General
************************************************************************/
bool useMagnetometer = false; // Can be toggled with BLE (disableMagnetometerRx)

void LedRed()  //BLE disconnecte
{
  digitalWrite(LEDR, LOW);
  digitalWrite(LEDB, HIGH);
}

void LedBlue()   //BLE connected
{
  digitalWrite(LEDR, HIGH);
  digitalWrite(LEDB, LOW);
}

/************************************************************************
* BLE Characteristic / Service UUIDs
************************************************************************/

#define LOCAL_NAME "Move!"

#define UUID_GEN(val) ("81c30e5c-" val "-4f7d-a886-de3e90749161")

BLEService                         moveService                   (UUID_GEN("0000"));

BLECharacteristic               dataProviderTxChar            (UUID_GEN("1001"), BLERead | BLENotify, 9 * FLOAT_BYTE_SIZE);
BLECharacteristic                  dataProviderLabelsTxChar      (UUID_GEN("1002"), BLERead, 128);
BLEUnsignedCharCharacteristic      versionTxChar                 (UUID_GEN("1003"), BLERead);

//BLECharacteristic               inferenceTxChar           (UUID_GEN("1004"), BLERead | BLENotify, 3);

//BLEUnsignedCharCharacteristic   numClassesRxChar          (UUID_GEN("2001"), BLEWrite);
//BLEIntCharacteristic            numSamplesRxChar          (UUID_GEN("2002"), BLEWrite);
//BLEIntCharacteristic            captureDelayRxChar        (UUID_GEN("2003"), BLEWrite);
//BLEFloatCharacteristic          thresholdRxChar           (UUID_GEN("2004"), BLEWrite);
//BLEBoolCharacteristic           disableMagnetometerRx     (UUID_GEN("2005"), BLEWrite);
//
//BLEUnsignedCharCharacteristic   stateRxChar               (UUID_GEN("3001"), BLEWrite);
//BLEUnsignedCharCharacteristic   stateTxChar               (UUID_GEN("3002"), BLERead | BLENotify);
//BLEUnsignedCharCharacteristic   fileTransferTypeRxChar    (UUID_GEN("3003"), BLEWrite);
//BLEBoolCharacteristic           hasModelTxChar            (UUID_GEN("3004"), BLERead | BLENotify);
//
//// Meta is for future-proofing, we can use it to store and read any 64 bytes
//BLECharacteristic               metaRxChar                (UUID_GEN("4001"), BLEWrite, 64);
//BLECharacteristic               metaTxChar                (UUID_GEN("4002"), BLERead, 64);


/************************************************************************
* Main / Lifecycle
************************************************************************/

void setup()
{

  Serial.begin(9600);
  const int startTime = millis();

  // Give serial port 2 second to connect.
  while (!Serial && millis() - startTime < 2000);

  // Prepare LED pins.
  pinMode(LED_BUILTIN, OUTPUT);

  // Initialize IMU sensors
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  moveService.addCharacteristic(versionTxChar);
  moveService.addCharacteristic(dataProviderTxChar);
  moveService.addCharacteristic(dataProviderLabelsTxChar);
//  service.addCharacteristic(inferenceTxChar);
//
//  service.addCharacteristic(numClassesRxChar);
//  service.addCharacteristic(numSamplesRxChar);
//  service.addCharacteristic(captureDelayRxChar);
//  service.addCharacteristic(thresholdRxChar);
//  service.addCharacteristic(disableMagnetometerRx);
//
//  service.addCharacteristic(stateRxChar);
//  service.addCharacteristic(stateTxChar);
//  service.addCharacteristic(fileTransferTypeRxChar);
//  service.addCharacteristic(hasModelTxChar);
//
//  service.addCharacteristic(metaRxChar);
//  service.addCharacteristic(metaTxChar);

  // Start the core BLE engine.
  if (!BLE.begin())
  {
    Serial.println("Failed to initialized BLE!");
    while (1);
  }

  String address = BLE.address();

  // Output BLE settings over Serial.
  Serial.print("address = ");
  Serial.println(address);

  address.toUpperCase();

  static String deviceName = LOCAL_NAME;
  deviceName += " - ";
  deviceName += address[address.length() - 5];
  deviceName += address[address.length() - 4];
  deviceName += address[address.length() - 2];
  deviceName += address[address.length() - 1];

  Serial.print("deviceName = ");
  Serial.println(deviceName);

  Serial.print("localName = ");
  Serial.println(deviceName);

  // Set up properties for the whole service.
  BLE.setLocalName(deviceName.c_str());
  BLE.setDeviceName(deviceName.c_str());
  BLE.setAdvertisedService(moveService);

  // Print out full UUID and MAC address.
  Serial.println("Peripheral advertising info: ");
  Serial.print("Name: ");
  Serial.println(LOCAL_NAME);
  Serial.print("MAC: ");
  Serial.println(BLE.address());
  Serial.print("Service UUID: ");
  Serial.println(moveService.uuid());

  // Start up the service itself.
  BLE.addService(moveService);

  BLE.advertise();

  Serial.println("Bluetooth device active, waiting for connections...");

  // Broadcast sketch version
  versionTxChar.writeValue(VERSION);

  // Used for Tiny Motion Trainer to label / filter values
  dataProviderLabelsTxChar.writeValue("acc.x, acc.y, acc.z, gyro.x, gyro.y, gyro.z, mag.x, mag.y, max.zl");

  Serial.println();

  // Get the TFL representation of the model byte array
  tflModel = tflite::GetModel(model);
  if (tflModel->version() != TFLITE_SCHEMA_VERSION) {
    Serial.println("Model schema mismatch!");
    while (1);
  }

  // Create an interpreter to run the model
  tflInterpreter = new tflite::MicroInterpreter(tflModel, tflOpsResolver, tensorArena, tensorArenaSize, &tflErrorReporter);

  // Allocate memory for the model's input and output tensors
  tflInterpreter->AllocateTensors();

  // Get pointers for the model's input and output tensors
  tflInputTensor = tflInterpreter->input(0);
  tflOutputTensor = tflInterpreter->output(0);

  Serial.println("end of setup");

}


void loop()
{
  LedRed();

  // Make sure we're connected and not busy file-transfering
  if (BLE.connected())
  {
    LedBlue();

     Serial.println("BLE connected");

     // Variables to hold IMU data
    float aX, aY, aZ, gX, gY, gZ;

    // Wait for motion above the threshold setting
    while (!isCapturing) {
      if (IMU.accelerationAvailable() && IMU.gyroscopeAvailable()) {

        IMU.readAcceleration(aX, aY, aZ);
        IMU.readGyroscope(gX, gY, gZ);

        // Sum absolute values
        float average = fabs(aX / 4.0) + fabs(aY / 4.0) + fabs(aZ / 4.0) + fabs(gX / 2000.0) + fabs(gY / 2000.0) + fabs(gZ / 2000.0);
        average /= 6.;

        // Above the threshold?
        if (average >= MOTION_THRESHOLD) {
          isCapturing = true;
          numSamplesRead = 0;
          break;
        }
      }
    }

    while (isCapturing) {
      // Check if both acceleration and gyroscope data is available
      if (IMU.accelerationAvailable() && IMU.gyroscopeAvailable()) {

        // read the acceleration and gyroscope data
        IMU.readAcceleration(aX, aY, aZ);
        IMU.readGyroscope(gX, gY, gZ);

        // Normalize the IMU data between -1 to 1 and store in the model's
        // input tensor. Accelerometer data ranges between -4 and 4,
        // gyroscope data ranges between -2000 and 2000
        tflInputTensor->data.f[numSamplesRead * 6 + 0] = aX / 4.0;
        tflInputTensor->data.f[numSamplesRead * 6 + 1] = aY / 4.0;
        tflInputTensor->data.f[numSamplesRead * 6 + 2] = aZ / 4.0;
        tflInputTensor->data.f[numSamplesRead * 6 + 3] = gX / 2000.0;
        tflInputTensor->data.f[numSamplesRead * 6 + 4] = gY / 2000.0;
        tflInputTensor->data.f[numSamplesRead * 6 + 5] = gZ / 2000.0;

        numSamplesRead++;

        // Do we have the samples we need?
        if (numSamplesRead == NUM_SAMPLES) {

          // Stop capturing
          isCapturing = false;

          // Run inference
          TfLiteStatus invokeStatus = tflInterpreter->Invoke();
          if (invokeStatus != kTfLiteOk) {
            Serial.println("Error: Invoke failed!");
            while (1);
            return;
          }

          // Loop through the output tensor values from the model
          int maxIndex = 0;
          float maxValue = 0;

          for (int i = 0; i < NUM_GESTURES; i++) {
            float _value = tflOutputTensor->data.f[i];

            if(_value > maxValue){
              maxValue = _value;
              maxIndex = i;
            }

            Serial.print(GESTURES[i]);
            Serial.print(": ");
            Serial.println(tflOutputTensor->data.f[i], 6);
          }

          Serial.print("Gesture: ");
          Serial.println(GESTURES[maxIndex]);

          int result = 0;

           // If the gestures is "PUNCH" print 1, "UPPERCUT" print 2

          if (String(GESTURES[maxIndex]).equals("PUNCH")) result = 1;
          else if (String(GESTURES[maxIndex]).equals("UPPERCUT")) result = 2;
//          else if (String(GESTURES[maxIndex]).equals("squat")) result = 3;
//          else if (String(GESTURES[maxIndex]).equals("dumbbell")) result = 4;

          dataProviderTxChar.writeValue((byte)result);

          Serial.println(result);
          Serial.println();

          BLE.advertise();

          // Add delay to not double trigger
          delay(CAPTURE_DELAY);
        }
      }
    }
  }

}