import 'package:flutter/material.dart';

class LoadInformation extends StatelessWidget {
  const LoadInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(
              image: AssetImage('assets/clouds.jpeg'),
              fit: BoxFit.fill)),
    ),
    Center(child: CircularProgressIndicator(color:Colors.white),),
      ],
    );
  }
}