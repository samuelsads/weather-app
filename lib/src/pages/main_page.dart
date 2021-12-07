import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wheater/src/models/weather.dart';
import 'package:wheater/src/models/weather_provider.dart';
import 'package:wheater/src/services/weather_services.dart';
import "package:wheater/src/utils/string_extension.dart";
import 'package:wheater/src/widgets/icon_nigh_day_widget.dart';
import 'package:wheater/src/widgets/more_information_widget.dart';
import 'package:wheater/src/widgets/sunrise_sunset_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Tiempo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext contexts) {
                    return Container(
                      height: 300,
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Mi ubicación actual'),
                            Container(
                                margin: EdgeInsets.all(15),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Código de tu país',
                                      hintText: 'Código de tu país',
                                      helperText: 'Ejemplo: MX = México ',
                                      helperStyle:
                                          TextStyle(color: Colors.red)),
                                )),
                            Container(
                                margin: EdgeInsets.all(15),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Código postal',
                                      hintText: 'Código postal',
                                      helperStyle:
                                          TextStyle(color: Colors.red)),
                                )),
                            ElevatedButton.icon(
                              icon: Icon(Icons.search),
                              label: const Text('Buscar'),
                              onPressed: () async {
                                final service = WeatherService();
                                Provider.of<WeatherProvider>(context,
                                            listen: false)
                                        .response =
                                    await service.getWeatherByZipCode(
                                        83550, "MX");
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
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
  Provider.of<WeatherProvider>(context, listen: false).response =
      await service.getWeatherByZipCode(0, "");
}

class _WheaterBody extends StatelessWidget {
  const _WheaterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = WeatherService();
    //Provider.of<WeatherProvider>(context, listen:false);
    loadInformation(context);

    return Builder(builder: (context) {
      Future.delayed(Duration(milliseconds: 500));
      final data = Provider.of<WeatherProvider>(context, listen: true).response;
      DateTime now = DateTime.now();
      print("tiempo: ${data?.sys.sunrise}");
      print("tiempo: ${data?.sys.sunset}");
      final weatherInformation = data?.main;
      var date =
          DateTime.fromMillisecondsSinceEpoch(data?.sys.sunrise ?? 0 * 1000);
      return Stack(
        children: [
          (now.isAfter(DateTime.fromMillisecondsSinceEpoch(
                    data?.sys.sunset ?? 0 * 1000))) ?Image.asset(
            'assets/night.jpeg',
            fit: BoxFit.fill,
            height: double.infinity,
          ):Image.asset(
            'assets/clouds.jpeg',
            fit: BoxFit.fill,
            height: double.infinity,
          ),
        
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                data?.name ?? '-----',
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
                      new DateTime.fromMillisecondsSinceEpoch(
                          data?.sys.sunrise ?? 0 * 1000),
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
                sunset: DateTime.fromMillisecondsSinceEpoch(
                    data?.sys.sunset ?? 0 * 1000),
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
                      (weatherInformation?.temp).toString().toString(),
                      style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text(
                (data?.weather[0].description).toString().capitalize(),
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MoreInformation(
                        'Min', weatherInformation?.tempMin ?? 0.0, true),
                    MoreInformation(
                        'Max', weatherInformation?.tempMax ?? 0.0, true),
                    MoreInformation(
                        'Act', weatherInformation?.feelsLike ?? 0.0, true),
                    MoreInformation(
                        'Hum',
                        ((weatherInformation?.humidity) ?? 0.0).toDouble(),
                        false),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}






