import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconNighDay extends StatelessWidget {
  final String icon;

  const IconNighDay({required this.icon});

  @override
  Widget build(BuildContext context) {

    return ZoomIn(
      child: Image.network('http://openweathermap.org/img/w/${icon}.png', height: 100,width: 100,fit: BoxFit.fill,),
    );
  }
}