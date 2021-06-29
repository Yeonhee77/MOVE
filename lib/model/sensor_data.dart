class SensorData {
  final double result;
  //final double pressure;
  final DateTime lastTime;

  SensorData(
      {
        required this.result,
        //this.pressure,
        DateTime? lastTime})
      : this.lastTime = lastTime ?? DateTime.now();
}