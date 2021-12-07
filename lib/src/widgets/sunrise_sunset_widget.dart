import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class SunriseSunset extends StatelessWidget {
  final String title;
  final DateTime subtitle;
  final IconData icon;
  final Color color;
  final String suffix;

  const SunriseSunset(@required this.title, @required this.subtitle,
      @required this.icon, @required this.color, @required this.suffix);

  @override
  Widget build(BuildContext context) {
    print("date: $subtitle");
    final TextStyle style = TextStyle(color: Colors.white);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          FaIcon(
            this.icon,
            color: this.color,
          ),
          Text(
            this.title,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Text(
            '${DateFormat.Hms().format(this.subtitle)} ${this.suffix} ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }
}