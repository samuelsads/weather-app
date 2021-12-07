

import 'package:flutter/material.dart';
import 'package:wheater/src/models/weather.dart';

class WeatherProvider with ChangeNotifier{
  WeatherResponse ? _response;

  set response( WeatherResponse? response){
    this._response = response;
    notifyListeners();
  }

  WeatherResponse? get response  => _response;

  

}