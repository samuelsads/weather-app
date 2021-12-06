import 'package:dio/dio.dart';
import 'package:wheater/src/models/weather.dart';

class WeatherService {
  final apiKey = '7734727818b798bfd5b3ec2a34acd62a';
  final baseUrl = 'https://api.openweathermap.org/data/2.5/weather?';
  final _dio  = Dio();

  Future<WeatherResponse> getWeatherByZipCode(int zipCode) async {
    if(zipCode ==0){
      zipCode = 24500;
    }
    final url  = '${this.baseUrl}zip=${zipCode},MX&appid=${this.apiKey}&units=metric&lang=es';
    final resp  = await this._dio.get(url);
    print(resp);
    final data  = WeatherResponse.fromJson(resp.data);
    return data;
  }
}
