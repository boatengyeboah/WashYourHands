import 'dart:convert';

import 'map_data.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future<List<MapData>> fetchMapData() async {
    final response =
        await http.get('https://save-planet.herokuapp.com/map_data');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<MapData> result = [];
      
      data['data'].forEach((mapDataJson) {
        result.add(MapData.fromJson(mapDataJson));
      });

      return result;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
