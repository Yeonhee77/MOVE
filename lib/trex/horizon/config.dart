class HorizonConfig {
  late final double cloudFrequency = 0.5;
  late final int maxClouds = 20;
  late final double bgCloudSpeed = 0.2;
}

class HorizonDimensions {
  late final double width = 1200.0;
  late final double height = 60.0;
  late final double yPos = 50.0;
}

class CloudConfig {
  late final double maxCloudGap = 400.0;
  late final double minCloudGap = 100.0;

  late final double maxSkyLevel = 71.0;
  late final double minSkyLevel = 30.0;

  late final double height = 24.0; // cloud container
  late final double width = 32.0; // cloud container
}
