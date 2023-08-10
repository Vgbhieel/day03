import 'package:ex00/app/domain/models/place.dart';
import 'package:flutter/material.dart';

class WeatherPlaceSearchAutocomplete extends StatefulWidget {
  final List<Place> _suggestions;
  final Function(String query) _onSearchChanged;
  final Function(Place suggestion) _onSuggestionSelected;
  final Function(String query) _onSearchSubmitted;

  const WeatherPlaceSearchAutocomplete({
    super.key,
    required List<Place> suggestions,
    required Function(String query) onSearchChanged,
    required Function(Place suggestion) onSuggestionSelected,
    required Function(String query) onSearchSubmitted,
  })  : _suggestions = suggestions,
        _onSearchChanged = onSearchChanged,
        _onSuggestionSelected = onSuggestionSelected,
        _onSearchSubmitted = onSearchSubmitted;

  @override
  State<WeatherPlaceSearchAutocomplete> createState() =>
      _WeatherPlaceSearchAutocompleteState();
}

class _WeatherPlaceSearchAutocompleteState
    extends State<WeatherPlaceSearchAutocomplete> {
  List<Place> _list = List.empty();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _list = widget._suggestions;
  }

  @override
  void didUpdateWidget(covariant WeatherPlaceSearchAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget._suggestions != widget._suggestions) {
      setState(() {
        _list = widget._suggestions;
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        _controller.notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Place>(
      textEditingController: _controller,
      focusNode: _focusNode,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onChanged: widget._onSearchChanged,
          onSubmitted: widget._onSearchSubmitted,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
            enabledBorder: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            hintText: 'Search location...',
          ),
        );
      },
      displayStringForOption: (option) {
        return buildDisplayString(option);
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          _list = List<Place>.empty();
        }
        return _list;
      },
      optionsViewBuilder: (context, onSelected, options) {
        var mOptions = options.toList();
        return Material(
          child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                Place item = mOptions[index];
                return ListTile(
                  title: Text(buildDisplayString(item)),
                  onTap: () {
                    onSelected.call(item);
                    FocusScope.of(context).unfocus();
                  },
                );
              }),
        );
      },
      onSelected: widget._onSuggestionSelected,
    );
  }

  String buildDisplayString(Place option) {
    String displayString = option.name;
    final String? region = option.region;
    final String? coutry = option.country;

    if (region != null) {
      displayString = "$displayString, $region";
    }

    if (coutry != null) {
      displayString = "$displayString, $coutry";
    }

    return displayString;
  }
}
