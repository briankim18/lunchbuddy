import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lunch_buddy/blocs/autocomplete/autocomplete_event.dart';
import 'package:lunch_buddy/blocs/geolocation_bloc.dart';
import 'package:lunch_buddy/blocs/geolocation_state.dart';
import 'package:lunch_buddy/widgets/Gmap.dart';
import 'blocs/autocomplete/autocomplete_bloc.dart';
import 'blocs/autocomplete/autocomplete_state.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}
class _LocationScreenState extends State<LocationScreen>{
  static const String routeName = '/location';
  @override

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => LocationScreen(),
      settings: RouteSettings(name: routeName),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: BlocBuilder<GeolocationBloc, GeolocationState>(
              builder: (context, state) {
                if (state is GeolocationLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if (state is GeolocationLoaded) {
                  return  Gmap(
                    lat: state.position.latitude,
                    lng: state.position.longitude,
                  );
                }
                else {
                  return Text("Something went wrong.");
                }
              },
            )),
          Positioned(
              top:40,
              left: 20,
              right: 20,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(
                    child: Column(
                      children: [
                        LocationSearchBox(),
                        BlocBuilder<AutocompleteBloc, AutocompleteState>(
                          builder: (context, state) {
                            if (state is AutocompleteLoading) {
                              return Center(child: CircularProgressIndicator(),
                              );
                            }
                            else if (state is AutocompleteLoaded) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                height: 300,
                                color: state.autocomplete.length > 0
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.transparent,
                                child: ListView.builder(
                                    itemCount: state.autocomplete.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          state.autocomplete[index].description ,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: Colors.white,
                                        ),
                                      ),
                                      );
                                    }),
                              );
                            }
                            else {
                              return Text("Something went wrong.");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
                ),
              )
          ),
          Positioned(
            bottom:100,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: ElevatedButton(
                child: Text('Save'),
                onPressed:  () {},

              ),
            ),
          ),
          Positioned(
            bottom:150,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: ElevatedButton(
                child: Text('Date To Meet'),
                onPressed:  () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}


class LocationSearchBox extends StatelessWidget {
  const LocationSearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutocompleteBloc, AutocompleteState>(
      builder: (context, state)
    {
      if (state is AutocompleteLoading) {
        return Center(child: CircularProgressIndicator(),
        );
      }
      if (state is AutocompleteLoaded) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter Your Location',
              suffixIcon: Icon(Icons.search),
              contentPadding:
              const EdgeInsets.only(left: 20, bottom: 5, right: 5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              context.read<AutocompleteBloc>().add(LoadAutocomplete(searchInput: value));
            },
          ),
        );
        }
      else {
        return Text("Something went wrong");
      }
      });
  }
}