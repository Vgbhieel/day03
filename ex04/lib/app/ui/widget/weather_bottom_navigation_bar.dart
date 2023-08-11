import 'package:flutter/material.dart';

class WeatherBottomNavigationBar extends StatelessWidget {
  const WeatherBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.secondaryContainer,
      child: const TabBar(isScrollable: false, tabs: [
        Tab(
          icon: Icon(Icons.sunny),
          text: "Currently",
        ),
        Tab(
          icon: Icon(Icons.today),
          text: "Today",
        ),
        Tab(
          icon: Icon(Icons.calendar_month),
          text: "Weekly",
        ),
      ]),
    );
  }
}
