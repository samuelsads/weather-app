import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wheater/src/models/weather.dart';

class WeatherService {
  final apiKey = '7734727818b798bfd5b3ec2a34acd62a';
  final baseUrl = 'https://api.openweathermap.org/data/2.5/weather?';
  final _dio = Dio();

  Future<WeatherResponse> getWeatherByLocation(Position position) async{
    print(position.latitude);
    print(position.longitude);
    final url = '${baseUrl}lat=${position.latitude}&lon=${position.longitude}&units=metric&lang=es&appid=${apiKey}';
    dynamic resp;
    WeatherResponse data;
    try {
      resp = await _dio.get(url);
      data = WeatherResponse.fromJson(resp.data);
    } catch (e) {
      resp = WeatherResponse(
          coord: Coord(lon: -99.1965, lat: 19.3532),
          weather: <Weather>[Weather(id: 1, description: "----")],
          main: Main(
              temp: 0,
              feelsLike: 0,
              tempMin: 0,
              tempMax: 0,
              pressure: 0,
              humidity: 0),
          sys: Sys(country: "----", sunrise: 0, sunset: 0),
          id: 1,
          name: "",
          cod: 404);
      data = resp;
    }
    return data;
  }

  Future<WeatherResponse> getWeatherByZipCode(
      String zipCode, String countryCode) async {
    dynamic resp;
    WeatherResponse data;
    if (zipCode == "0") {
      zipCode = "24500";
      countryCode = "MX";
    }
    final url =
        '${this.baseUrl}zip=${zipCode},${countryCode}&appid=${this.apiKey}&units=metric&lang=es';

    try {
      resp = await _dio.get(
        url,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status == 200;
          },
        ),
      );
      data = WeatherResponse.fromJson(resp.data);
    } catch (e) {
      resp = WeatherResponse(
          coord: Coord(lon: -99.1965, lat: 19.3532),
          weather: <Weather>[Weather(id: 1, description: "----")],
          main: Main(
              temp: 0,
              feelsLike: 0,
              tempMin: 0,
              tempMax: 0,
              pressure: 0,
              humidity: 0),
          sys: Sys(country: "----", sunrise: 0, sunset: 0),
          id: 1,
          name: "",
          cod: 404);
      data = resp;
    }

    return data;
  }
}
