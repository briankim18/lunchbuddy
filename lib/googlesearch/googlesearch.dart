import 'dart:typed_data';

import 'package:http/http.dart' as http;

// Replace with your own API key
import 'dart:convert';
import 'package:http/http.dart' as http;
// Function to search Google using the SerpAPI
Future<String> searchGoogle(String query, String tbm, String ijn, String apiKey) async {
  const String apiKey = '984a847dbf88a989d6e26f6cdcb226f46e71cad086a5568a435065afbf184895';

  // Construct the URL for the API request
  String url = 'https://serpapi.com/search?q=$query&tbm=$tbm&ijn=$ijn&api_key=$apiKey';

  // Send the request and get the response
  http.Response response = await http.get(Uri.parse(url));


  // Return the response body as a string
  return response.body;
}
// Function to download the image data from the specified URL
Future<Uint8List> downloadImage(String url) async {
  // Send a GET request to the URL and get the response
  http.Response response = await http.get(Uri.parse(url));

  // Return the response body as a Uint8List
  return response.bodyBytes;
}
// Example usage: search for "Apple" on Google Images
void main2() async {
  String result = await searchGoogle('Apple', 'isch', '0', '984a847dbf88a989d6e26f6cdcb226f46e71cad086a5568a435065afbf184895');

  // Parse the JSON response
  var results = json.decode(result);

  // Get the "images_results" array from the results
  var images_results = results['images_results'];
}
