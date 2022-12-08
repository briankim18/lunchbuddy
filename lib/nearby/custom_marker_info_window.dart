import 'dart:async';
import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lunch_buddy/globals/restaurant_coords.dart';
import 'package:lunch_buddy/new_public_request.dart';
import 'package:google_maps_webservice/geocoding.dart';
import '../nearby/nearbyplaces.dart';

class CustomMarketInfoWindow extends StatefulWidget {
  const CustomMarketInfoWindow({Key? key}) : super(key: key);

  @override
  State<CustomMarketInfoWindow> createState() => _CustomMarketInfoWindowState();
}

class _CustomMarketInfoWindowState extends State<CustomMarketInfoWindow> {

  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = [];  //markers with restaurants

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  double currentLat = 0.0;
  double currentLng = 0.0;
  String type = 'restaurant';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadData();
    navigateToCurrentPosition();
    // getNearbyPlaces();
    // loadData();
  }

  loadData() {
    if (nearbyPlacesResponse.results != null) {
      for (int i = 0; i < nearbyPlacesResponse.results!.length; i++) {
        addMarkers(nearbyPlacesResponse.results![i], i);
      }
    }
  }

  void addMarkers(Results results, int i) {
    _marker.add(Marker(
      onTap: () async {
        final geocoding = GoogleMapsGeocoding(
            apiKey: 'AIzaSyBwRIxToOIBRwjj1NgMFweD-iDn9Dcgzqk');
        final response = await geocoding.searchByPlaceId(results.placeId!);
        final result =  response.results[0].formattedAddress;
        globalLatString = results.geometry!.location!.lat!.toString();
        globalLongString = results.geometry!.location!.lng!.toString();
        globalPlaceId = results.placeId!;
        restaurantName = results.name!;
        formattedAddress = result!;
        photoUrl = results.icon!;

        print("-----------");
        print(photoUrl);
        final split = formattedAddress.split(',');
        final split2 = formattedAddress.split(' ');
        final Map<int, String> values = {
          for (int k = 0; k < split.length; k++)
            k: split[k]
        };
        final Map<int, String> values2 = {
          for (int k = 0; k < split2.length; k++)
            k: split2[k]
        };
        final valueCity = values[1];
        final valuesState = values2[5];
        globalCity = valueCity!;
        globalState = valuesState!;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPublicRequestPage()),
        );
      },
      markerId: MarkerId(i.toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(
          results.geometry!.location!.lat!, results.geometry!.location!.lng!),
    ));

    setState(() {});
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('error in getting current location');
      debugPrint(error.toString());
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
  void navigateToCurrentPosition() {
    getUserCurrentLocation().then((value) async {
      debugPrint('My current location');
      debugPrint(value.latitude.toString() + value.longitude.toString());

      _marker.add(Marker(
          markerId: MarkerId("yeiuwe87"),
          position: LatLng(value.latitude, value.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: InfoWindow(
            title: 'My current location',
          )));

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 15,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {
        currentLat = value.latitude;
        currentLng = value.longitude;
        getNearbyPlaces(type);
      });
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Restaurant"),
                  ),
                ];
              }, onSelected: (value) {
            if (value == 0) {
              type = 'restaurant';
              getNearbyPlaces(type);
            }
          }),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_marker),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 0,
            width: 0,
            offset: 0,
          )
        ],
      ),
    );
  }

  void getNearbyPlaces(String type) async {
    _marker.clear();
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            currentLat.toString() +
            ',' +
            currentLng.toString() +
            '&radius=1500&type=' +
            type +
            '&key=AIzaSyBwRIxToOIBRwjj1NgMFweD-iDn9Dcgzqk');

    var response = await http.post(url);

    print("printing latlng");
    print(jsonDecode(response.body));
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    print("printing latlng");
    print(jsonDecode(response.body));
    loadData();
    setState(() {});
  }

  void getImage(String restaurantNames) async {
    var url = Uri.parse(
      "https://serpapi.com/search.json?q=$restaurantNames&tbm=isch&ijn=0"
    );
    var response = await http.get(url);
    print("print image url");
    

  }
}