import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({this.startLng, this.startLat, this.endLng, this.endLat});

  final String url = 'https://api.openrouteservice.org/v2/directions/';
  final String apiKey =
      '5b3ce3597851110001cf6248afb01736215d46a09b8a22d3cd938b6d';
  final String journeyMode =
      'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(
        '$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print(
        "$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

class Distance {
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;
  final String journeyMode = 'driving-car';
  final String url = 'https://api.openrouteservice.org/v2/matrix/';
  final String apiKey =
      '5b3ce3597851110001cf6248afb01736215d46a09b8a22d3cd938b6d';
  final String metrics = 'distance';

  Distance({this.startLat, this.startLng, this.endLat, this.endLng});

  Future postData() async {
    http.Response response = await http.post(
      Uri.parse('$url$journeyMode'),
      headers: <String, String>{
        'Accept':
            'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Authorization': '$apiKey',
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: jsonEncode(<String, dynamic>{
        'locations': [[startLng,startLat],[endLng,endLat]],
        'metrics': ['$metrics'],
        'units': 'km'
      }),
    );
    print("$url$journeyMode");
    print(jsonEncode(<String, dynamic>{
      'locations': [[startLng,startLat],[endLng,endLat]],
      'metrics': ['$metrics'],
      'units': 'km'
    }));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      return response.statusCode;

    }
  }
}
