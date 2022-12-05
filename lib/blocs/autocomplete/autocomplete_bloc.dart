import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lunch_buddy/blocs/autocomplete/autocomplete_state.dart';
import 'package:lunch_buddy/models/place_autocomplete_model.dart';
import 'package:lunch_buddy/places/places_repository.dart';
import 'autocomplete_event.dart';

class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  final PlacesRepository _placesRepository;
  StreamSubscription? _placesSubscription;

  AutocompleteBloc({required PlacesRepository placesRepository}) :
        _placesRepository = placesRepository,
        super(AutocompleteLoading());

  @override
  Stream<AutocompleteState> mapEventToState(
      AutocompleteEvent event,
      ) async* {
      if (event is LoadAutocomplete) {
        yield* _mapLoadAutocompleteToState(event);
      }
  }
  Stream<AutocompleteState> _mapLoadAutocompleteToState(
      LoadAutocomplete event
      ) async* {
    _placesSubscription?.cancel();
    final List<PlaceAutocomplete> autocomplete =
      await _placesRepository.getAutocomplete(event.searchInput);

    yield AutocompleteLoaded(autocomplete: autocomplete);


  }
}