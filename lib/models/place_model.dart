import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String placeId;
  final String name;
  final double lat;
  final double lon;

  Place({
    this.placeId = '',
    this.name = '',
    required this.lat,
    required this.lon,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    if (json.keys.contains('place_id')) {
      return Place(
        placeId: json['place_id'],
        name: json['name'],
        lat: json['geometry']['location']['lat'],
        lon: json['geometry']['location']['lng'],
      );
    } else {
      return Place(
        placeId: json['placeId'],
        name: json['name'],
        lat: json['lat'],
        lon: json['lon'],
      );
    }
  }

  @override
  List<Object?> get props => [placeId, name, lat, lon];
}