import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lunch_buddy/blocs/place/place_event.dart';
import 'package:lunch_buddy/blocs/place/place_state.dart';
import 'package:lunch_buddy/places/places_repository.dart';

import '../../models/place_model.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlacesRepository _placeRepository;
  StreamSubscription? _placesSubscription;
  PlaceBloc({required PlacesRepository placesRepository}) :
      _placeRepository = placesRepository,
        super(PlaceLoading());

  @override
  Stream<PlaceState> mapEventToState(
      PlaceEvent event,
      ) async* {
    if (event is LoadPlace) {
      yield* _mapLoadPlaceToState(event);
    }
  }
  Stream<PlaceState> _mapLoadPlaceToState(LoadPlace event) async* {
    yield PlaceLoading();
    try {
      _placesSubscription?.cancel();
      final Place place = await _placeRepository.getPlace(event.placeId);
      yield PlaceLoaded(place: place);
    } catch (_) {}
  }
  @override
  Future<void> close() {
    _placesSubscription?.cancel();
    return super.close();
  }
}