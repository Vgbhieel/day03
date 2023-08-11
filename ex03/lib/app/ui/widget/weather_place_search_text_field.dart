import 'dart:async';

import 'package:ex00/app/domain/controllers/search_place_controller.dart';
import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/ui/widget/weather_place_search_autocomplete.dart';
import 'package:flutter/material.dart';

class WeatherPlaceSearcher extends StatefulWidget {
  final Function(Place suggestion) _onPlaceSelected;

  const WeatherPlaceSearcher({
    super.key,
    required Function(Place) onPlaceSelected,
  }) : _onPlaceSelected = onPlaceSelected;

  @override
  State<WeatherPlaceSearcher> createState() => _WeatherPlaceSearcherState();
}

class _WeatherPlaceSearcherState extends State<WeatherPlaceSearcher> {
  late final SearchPlaceController controller;
  List<Place> suggestions = List.empty();
  Timer? _debounceTimer;

  @override
  void initState() {
    controller = SearchPlaceController(
        onSuggestionsSuccess: _onSuggestionsSuccess,
        onSuggestionsError: _onSuggestionsError,
        onSearchSuccess: widget._onPlaceSelected,
        onSearchError: () {
          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Text('Ops, something went wrong. Please try again.',
                style: TextStyle(color: Theme.of(context).colorScheme.onError)),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
    super.initState();
  }

  void _onSuggestionsSuccess(List<Place> result) {
    setState(() {
      suggestions = result;
    });
  }

  void _onSuggestionsError() {
    setState(() {
      suggestions = List.empty();
    });

    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text('Ops, something went wrong. Please try again.',
          style: TextStyle(color: Theme.of(context).colorScheme.onError)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return WeatherPlaceSearchAutocomplete(
      suggestions: suggestions,
      onSearchChanged: _onSearchChanged,
      onSuggestionSelected: widget._onPlaceSelected,
      onSearchSubmitted: _onSearchSubmitted,
    );
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      controller.searchPlacesWithQuery(query);
    });
  }

  void _onSearchSubmitted(String query) {
    _debounceTimer?.cancel();
    controller.getPlaceWithQuery(query);
  }
}
