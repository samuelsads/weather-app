import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconNighDay extends StatelessWidget {
  final DateTime sunset;

  const IconNighDay({required this.sunset});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return ZoomIn(
      child: FaIcon(
        (now.isAfter(sunset)) ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
        color: (now.isAfter(sunset)) ? Colors.white : Colors.yellow,
        size: 50,
      ),
    );
  }
}