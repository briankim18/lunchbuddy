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