import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TemperaturInformation extends StatelessWidget {
  const TemperaturInformation(
      {Key? key,
      required this.title,
      required this.data,
      required this.icon,
      this.isPorcent})
      : super(key: key);

  final double data;
  final String title;
  final IconData icon;
  final bool? isPorcent;

  @override
  Widget build(BuildContext context) {
    String nomenclature;
    if (isPorcent ?? false) {
      nomenclature = '%';
    } else {
      nomenclature = '°C';
    }
    final size = MediaQuery.of(context).size;
    TextStyle _style = TextStyle(color: Colors.white, fontSize: 15);
    return Container(
      height: 110,
      width: size.width * 0.42,
      child: Card(
        color: Colors.transparent,
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: _style,
              ),
            ),
            FaIcon(
              icon,
              color: Colors.white,
            ),
            Text('$data $nomenclature', style: _style),
          ],
        ),
      ),
    );
  }
}
