import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wheater/src/models/weather_provider.dart';
import 'package:wheater/src/services/weather_services.dart';


searchNewCity(BuildContext context,String title){
if (Platform.isAndroid) {
    return showDialog(
      
        context: context,
        builder: (_) => AlertDialog(
              //backgroundColor: Colors.transparent,
              content: _searchNewLocation(context),
            ));
  } else if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Center(child: _searchNewLocation(context)),
            ));
  }
}

Widget _searchNewLocation(BuildContext context) {
  TextEditingController country = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  return Container(

    height: 300,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Mi ubicación actual'),
          Container(
              child: TextFormField(
                controller: country,
                decoration: InputDecoration(
                    labelText: 'Código de tu país',
                    hintText: 'Código de tu país',
                    helperText: 'Ejemplo: MX = México ',
                    helperStyle: TextStyle(color: Colors.red)),
              )),
          Container(
              child: TextFormField(
                controller: zipCode,
                decoration: InputDecoration(
                    labelText: 'Código postal',
                    hintText: 'Código postal',
                    helperStyle: TextStyle(color: Colors.red)),
              )),
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.search),
              label: const Text('Buscar'),
              onPressed: () async {
                final service = WeatherService();
                final response = await service.getWeatherByZipCode(
                    zipCode.text, country.text);
                if (response.cod != 200) {
                  Fluttertoast.showToast(
                      msg: "Ciudad no encontrada",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .response = response;
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    ),
  );
}

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(titulo),
                content: Text(subtitulo),
                actions: <Widget>[
                  MaterialButton(
                    child: Text('Ok'),
                    elevation: 3,
                    textColor: Colors.blue,
                    onPressed: () => Navigator.pop(context),
                  )
                ]));
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(titulo),
            content: Text(subtitulo),
            actions: [
              CupertinoDialogAction(
                child: Text('Ok'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}

loadingAlert(BuildContext context, String title) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              //backgroundColor: Colors.transparent,
              title: Text(title),
              content: SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator())),
            ));
  } else if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Center(child: CircularProgressIndicator()),
            ));
  }
}
