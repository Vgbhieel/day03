import 'package:ex00/app/domain/models/place.dart';
import 'package:ex00/app/ui/widget/weather_place_search_text_field.dart';
import 'package:flutter/material.dart';

class WeatherAppBar extends StatelessWidget {
  final Function(Place) _onPlaceSelected;
  final Function() _onGeolocationClicked;

  const WeatherAppBar({
    super.key,
    required Function(Place) onPlaceSelected,
    required Function() onGeolocationClicked,
  })  : _onPlaceSelected = onPlaceSelected,
        _onGeolocationClicked = onGeolocationClicked;

  @override
  AppBar build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AppBar(backgroundColor: theme.colorScheme.inversePrimary, actions: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: WeatherPlaceSearcher(
                  onPlaceSelected: (place) {
                    _onPlaceSelected(place);
                  },
                ),
              ),
              Flexible(
                flex: 0,
                child: Center(
                  child: VerticalDivider(
                    thickness: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(45 / 360),
                  child: IconButton(
                    icon: Icon(Icons.navigation,
                        color: theme.colorScheme.primary),
                    onPressed: _onGeolocationClicked,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
