class MapData {
  final double latitude;
  final double longitude;
  final String city;
  final int infected;
  final int dead;
  final int recovered;

  MapData({
    this.latitude,
    this.longitude,
    this.city,
    this.infected,
    this.dead,
    this.recovered,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      city: json['city'],
      infected: json['infected'],
      dead: json['dead'],
      recovered: json['recovered'],
    );
  }
}
