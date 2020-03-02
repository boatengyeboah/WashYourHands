import 'dart:convert';

import 'package:saving_our_planet/country.dart';
import 'package:saving_our_planet/news.dart';
import 'package:saving_our_planet/sanitry_ranking.dart';

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

  static Future<List<News>> fetchNews() async {
    final response = await http.get('https://save-planet.herokuapp.com/news');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<News> result = [];

      data['data'].forEach((newsDataJson) {
        result.add(News.fromJson(newsDataJson));
      });

      return result;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<PlaceData>> fetchCountries() async {
    final response =
        await http.get('https://save-planet.herokuapp.com/get_countries');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<PlaceData> result = [];

      data['countries'].forEach((countryDataJson) {
        result.add(PlaceData(
            name: countryDataJson['name'],
            id: countryDataJson['id'].toString()));
      });

      return result;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<PlaceData>> fetchStates(String countryId) async {
    final response = await http.get(
        'https://save-planet.herokuapp.com/get_states?countryId=$countryId');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<PlaceData> result = [];

      data['states'].forEach((countryDataJson) {
        result.add(PlaceData(
            name: countryDataJson['name'],
            id: countryDataJson['id'].toString()));
      });

      return result;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<PlaceData>> fetchCities(String stateId) async {
    final response = await http
        .get('https://save-planet.herokuapp.com/get_cities?stateId=$stateId');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<PlaceData> result = [];

      data['cities'].forEach((countryDataJson) {
        result.add(PlaceData(
            name: countryDataJson['name'],
            id: countryDataJson['city_id'].toString()));
      });

      return result;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static inputSanitryEntry(String cityId, String countryId) async {
    final response = await http.get(
        'https://save-planet.herokuapp.com/sanitary_entry?cityId=$cityId&countryId=$countryId');
  }

  static Future<SanitryRankingResponse> fetchSanitryRanking() async {
    final response = await http
        .get('https://save-planet.herokuapp.com/sanitary_rankings');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<SanitryRanking> byCities = [];
      List<SanitryRanking> byCountries = [];

      data['data']['country_rankings'].forEach((d) {
        byCountries.add(SanitryRanking.fromJson(d));
      });

      data['data']['city_rankings'].forEach((d) {
        byCities.add(SanitryRanking.fromJson(d));
      });

      return SanitryRankingResponse(
          byCities: byCities, byCountries: byCountries);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
