// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
//
//
// class ConvertLatLng extends StatefulWidget {
//   const ConvertLatLng({Key? key}) : super(key: key);
//
//   @override
//   State<ConvertLatLng> createState() => _ConvertLatLngState();
// }
//
// class _ConvertLatLngState extends State<ConvertLatLng> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Convert Lat Lng to Address'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: ()async{
//               List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
//               List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
//
//
//               print(locations.last.latitude.toString() + locations.last.longitude.toString());
//               print(placemarks.reversed.last.country.toString() + placemarks.reversed.last.name.toString());
//             },
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                   color: Colors.green
//               ),
//
//               child: Center(
//                 child: Text(
//                     'Convert'
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }