import 'dart:async';
import 'dart:convert';
import 'package:ex00/app/domain/models/place.dart';
import 'package:http/http.dart' as http;

class SearchPlaceController {
  final Function(List<Place>) _onSuggestionsSuccess;
  final Function() _onSuggestionsError;
  final Function(Place) _onSearchSuccess;
  final Function() _onSearchError;

  SearchPlaceController({
    required Function(List<Place>) onSuggestionsSuccess,
    required Function() onSuggestionsError,
    required Function(Place) onSearchSuccess,
    required Function() onSearchError,
  })  : _onSuggestionsSuccess = onSuggestionsSuccess,
        _onSuggestionsError = onSuggestionsError,
        _onSearchSuccess = onSearchSuccess,
        _onSearchError = onSearchError;

  Future<void> searchPlacesWithQuery(String query) async {
    if (query.isEmpty) return;

    try {
      List<Place> list = await _getPlacesList(query);
      _onSuggestionsSuccess.call(list);
    } catch (e) {
      _onSuggestionsError.call();
    }
  }

  Future<void> getPlaceWithQuery(query) async {
    if (query.isEmpty) return;

    try {
      List<Place> list = await _getPlacesList(query, count: 1);
      if (list.isNotEmpty) {
        _onSearchSuccess(list.first);
      } else {
        _onSearchError();
      }
    } catch (e) {
      _onSearchError();
    }
  }

  Future<List<Place>> _getPlacesList(String query, {int? count}) async {
    final queryParameters = {
      'name': query,
      'count': '${count ?? 10}',
      'language': 'pt',
      'format': 'json',
    };

    var response = await http.get(
      Uri.https('geocoding-api.open-meteo.com', '/v1/search', queryParameters),
    );

    var decodedResponse =
        (jsonDecode(utf8.decode(response.bodyBytes)) as Map)["results"];

    return List<Map<String?, dynamic>>.from(decodedResponse)
        .map((e) => _transformJson(e))
        .toList();
  }

  Place _transformJson(e) {
    String name = e["name"] as String;
    String country = e["country"] as String;
    String? region = e["admin1"] as String?;
    String? regionComplement = e["admin2"] as String?;

    return Place(
        name: name,
        country: _getCountryData(name, country),
        region: _getRegionData(region, regionComplement),
        coordinates: {
          (e["latitude"] as double).toString():
              (e["longitude"] as double).toString()
        });
  }

  String? _getCountryData(String name, String country) {
    if (country == name) {
      return null;
    } else {
      return country;
    }
  }

  String? _getRegionData(String? region, String? regionComplement) {
    if (regionComplement != null) {
      return "$region, $regionComplement";
    } else {
      return region;
    }
  }
}
