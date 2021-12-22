import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wheater/src/blocs/blocs.dart';
import 'package:wheater/src/helpers/mostrar_alerta.dart';
import 'package:wheater/src/helpers/toast.dart';
import 'package:wheater/src/models/weather_provider.dart';
import 'package:wheater/src/services/weather_services.dart';
import "package:wheater/src/utils/string_extension.dart";
import 'package:wheater/src/widgets/icon_nigh_day_widget.dart';
import 'package:wheater/src/widgets/sunrise_sunset_widget.dart';
import 'package:wheater/src/widgets/temperature_information.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(child: BlocBuilder<GpsBloc, GpsState>(
          builder: (BuildContext context, state) {
            if (!state.isGpsEnabled) {
              return ElevatedButton.icon(
                  onPressed: () async {
                    final gpsBloc = BlocProvider.of<GpsBloc>(context);
                    //final gpsBloc  = context.read<GpsBloc>();
                    if (!gpsBloc.state.isGpsEnabled) {
                      viewToastAlert('Activar gps');
                    }
                    gpsBloc.askGpsAccess();
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    size: 15,
                  ),
                  label: Text('Activar GPS'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, elevation: 0));
            } else {
              return ElevatedButton.icon(
                  onPressed: () async {
                    //final status  = await Permission.location.request();
                    //accesoGps(status);
                    final gpsBloc = context.read<GpsBloc>();

                    if (state.isGpsPermissionGranted) {
                      loadingAlert(context, 'Buscando');
                      Position position = await gpsBloc.getLocation();
                      final service = WeatherService();
                      final response =
                          await service.getWeatherByLocation(position);
                      if (response.cod != 200) {
                        viewToastAlert("Ciudad no encontrada");
                      } else {
                        Provider.of<WeatherProvider>(context, listen: false)
                            .response = response;
                      }
                      Navigator.pop(context);
                    } else {
                      gpsBloc.askGpsAccess();
                    }
                  },
                  icon: Icon(
                    Icons.gps_fixed,
                    size: 15,
                  ),
                  label: Text('GPS activo, clic para buscar ubicación'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, elevation: 0));
            }
          },
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                searchNewCity(context, "Buscar nueva ciudad");
              },
              icon: FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: _WheaterBody(),
    );
  }
}



loadInformation(BuildContext context) async {
  final service = WeatherService();
  final bloc = BlocProvider.of<GpsBloc>(context);
  Provider.of<WeatherProvider>(context, listen: false).response =
      await service.getWeatherByZipCode('0', "");
}

class _WheaterBody extends StatelessWidget {
  const _WheaterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = WeatherService();
    //Provider.of<WeatherProvider>(context, listen:false);
    loadInformation(context);
    //Future.delayed(Duration(milliseconds: 1000));
    return Builder(builder: (context) {
      final data = Provider.of<WeatherProvider>(context, listen: true).response;
      DateTime now = DateTime.now();
      int sunrise = 0;
      int sunset = 0;

      if (data?.sys.sunrise != null) {
        sunrise = data!.sys.sunrise;
      }

      if (data?.sys.sunset != null) {
        sunset = data!.sys.sunset;
      }
      final weatherInformation = data?.main;
      return Stack(
        children: [
          Container(
          decoration: new BoxDecoration(image: new DecorationImage(image:  (now.isAfter(DateTime.fromMillisecondsSinceEpoch(
                  (data?.sys.sunset ?? 0) * 1000)))? AssetImage('assets/night.jpeg') :AssetImage('assets/clouds.jpeg'), fit: BoxFit.fill)),
        ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                  ),
                  Text(
                    data?.name ?? '-----',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SunriseSunset(
                          "Amanecer",
                          new DateTime.fromMillisecondsSinceEpoch(sunrise * 1000),
                          FontAwesomeIcons.sun,
                          Colors.yellow,
                          "AM"),
                      SunriseSunset(
                          "Puesta de sol",
                          new DateTime.fromMillisecondsSinceEpoch(
                              data?.sys.sunset ?? 0 * 1000),
                          FontAwesomeIcons.moon,
                          Colors.white,
                          "PM"),
                    ],
                  ),
                  IconNighDay(
                    icon: data?.weather[0].icon ?? '01d',
                  ),
                  Stack(
                    children: [
                      Positioned(
                          right: 0,
                          top: 15,
                          child: Text(
                            '°C',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          (weatherInformation?.temp ?? '----').toString(),
                          style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (data?.weather[0].description ?? '----').capitalize(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 45, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TemperaturInformation(
                          icon: FontAwesomeIcons.temperatureLow,
                          title: "Temperatura mínima ",
                          data: weatherInformation?.tempMin ?? 0.0),
                      TemperaturInformation(
                          icon: FontAwesomeIcons.temperatureHigh,
                          title: "Temperatura máxima ",
                          data: weatherInformation?.tempMax ?? 0.0),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TemperaturInformation(
                          icon: FontAwesomeIcons.clock,
                          title: "Sensación termica ",
                          data: weatherInformation?.feelsLike ?? 0.0),
                      TemperaturInformation(
                          icon: FontAwesomeIcons.cloudRain,
                          title: "Humedad ",
                          data: (weatherInformation?.humidity ?? 0.0).toDouble())
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
