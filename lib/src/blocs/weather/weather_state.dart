part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  
  final WeatherResponse? weather;
  final bool? isLoadInformation;
  const WeatherState({this.weather, this.isLoadInformation});

  WeatherState copyWith({
    WeatherResponse? weather,
    bool? isLoadInformation,
  })=>WeatherState(weather: weather??this.weather, isLoadInformation: isLoadInformation??this.isLoadInformation);
  
  @override
  List<Object?> get props => [weather, isLoadInformation];


  @override
  String toString()=>'weather: $weather isLoadInformation $isLoadInformation';
}


