class SensorData {
  final double left;
  final double jump;
  //final double pressure;
  final DateTime lastTime;

  SensorData(
      {
      this.left,
      this.jump,
      //this.pressure,
      DateTime lastTime})
      : this.lastTime = lastTime ?? DateTime.now();
}
