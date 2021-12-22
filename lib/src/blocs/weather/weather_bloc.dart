import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wheater/src/models/weather.dart';
import 'package:wheater/src/services/weather_services.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final service = WeatherService();
  WeatherBloc() : super(const WeatherState()) {
    on<WeatherInformationEvent>((event, emit) => emit(state.copyWith(
        weather: event.weather, isLoadInformation: event.isLoadInformation)));
    findInformation();
  }

  Future<WeatherResponse> findInformation({String zipCode='0', String countryCode=""}) async {
    
    final response = await service.getWeatherByZipCode(zipCode, countryCode);
    if(response.cod==200){
      add(WeatherInformationEvent(weather: response, isLoadInformation: true));
    }
    return response;
  }

  Future<WeatherResponse> findInformationByGps(Position position) async{
    final response = await service.getWeatherByLocation(position);
    if(response.cod == 200){
      add(WeatherInformationEvent(weather: response,isLoadInformation: true));
    }
    return response;
  }
}
