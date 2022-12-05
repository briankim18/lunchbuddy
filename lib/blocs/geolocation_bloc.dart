import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_buddy/blocs/geolocation_event.dart';
import 'package:lunch_buddy/blocs/geolocation_state.dart';
import 'package:lunch_buddy/repositories/geolocation/geolocation_repository.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocationRepository _geolocationRepository;
  StreamSubscription? _geolocationSubscription;

  GeolocationBloc({required GeolocationRepository geolocationRepository}) :
      _geolocationRepository = geolocationRepository,
      super(GeolocationLoading());

  @override
  Stream<GeolocationState> mapEventToState(
      GeolocationEvent event,
      ) async* {
    if (event is LoadGeolocation) {
      yield* _mapLoadGeolocationToState();
    }
    else if (event is UpdateGeolocation) {
      yield* _mapUpdateGeolocationToState(event);
    }
  }
  Stream<GeolocationState> _mapLoadGeolocationToState() async* {
    _geolocationSubscription?.cancel();
     final Position position = await _geolocationRepository.getCurrentLocation();
     add(UpdateGeolocation(position));
  }

  Stream<GeolocationState> _mapUpdateGeolocationToState(UpdateGeolocation event) async* {
    yield GeolocationLoaded(position: event.position);
  }

  @override
  Future<void> close() {
    _geolocationSubscription?.cancel();
    return super.close();
  }
}