import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheater/src/blocs/blocs.dart';
import 'package:wheater/src/blocs/weather/weather_bloc.dart';
import 'package:wheater/src/models/weather_provider.dart';
import 'package:wheater/src/pages/main_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => GpsBloc(),
      ),
      BlocProvider(
        create: (context) => WeatherBloc(),
      ),
    ],
    child: MyApp(),
  )
  );
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: ChangeNotifierProvider(
        create: (_)=>WeatherProvider(),
        child: MainPage()),
    );
  }
}