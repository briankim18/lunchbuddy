import 'package:equatable/equatable.dart';

import '../../models/place_model.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final Place place;
  const PlaceLoaded({required this.place});

  @override
  List<Object> get props => [place];

}

class PlaceError extends PlaceState {}