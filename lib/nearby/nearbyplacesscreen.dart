import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../nearby/nearbyplaces.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String apiKey = "AIzaSyBwRIxToOIBRwjj1NgMFweD-iDn9Dcgzqk";
  String radius = "30";
  double latitude = 31.5111093;
  double longitude = 74.279664;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              getNearbyPlaces();
            }, child: const Text("Get Nearby Places")),

            if(nearbyPlacesResponse.results != null)
              for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
                nearbyPlacesWidget(nearbyPlacesResponse.results![i])
          ],
        ),
      ),
    );
  }

  void getNearbyPlaces() async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.68060824514047,73.0151709698594&radius=1500&type=restaurant,hospital&key=AIzaSyBwRIxToOIBRwjj1NgMFweD-iDn9Dcgzqk');
    var response = await http.post(url);
    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: ${results.name!}"),
          Text("Location: ${results.geometry!.location!.lat} , ${results.geometry!.location!.lng}"),
          Text('Type:${results.types}'),
        ],
      ),
    );
  }
}