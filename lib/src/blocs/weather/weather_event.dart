part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {

  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherInformationEvent extends WeatherEvent{
  final WeatherResponse? weather;
  final bool isLoadInformation;

  const WeatherInformationEvent({this.weather, required this.isLoadInformation});  

}
