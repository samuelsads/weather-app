import 'package:flutter/material.dart';

class MoreInformation extends StatelessWidget {
  final String title;
  final double subtitle;
  final bool isTemperature;

  const MoreInformation(
      @required this.title, @required this.subtitle, this.isTemperature);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(color: Colors.white);
    return Container(
      height: 45,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(
            this.title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '${this.subtitle}${(isTemperature) ? "°C" : ""}',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }
}