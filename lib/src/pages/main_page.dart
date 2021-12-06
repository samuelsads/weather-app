import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wheater/src/models/weather.dart';
import 'package:wheater/src/services/weather_services.dart';
import "package:wheater/src/utils/string_extension.dart";

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
              onPressed: () async {}, icon: FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: _WheaterBody(),
    );
  }
}

class _WheaterBody extends StatelessWidget {
  const _WheaterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = WeatherService();
    return FutureBuilder(
        future: service.getWeatherByZipCode(0),
        builder:
            (BuildContext context, AsyncSnapshot<WeatherResponse> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            final weatherInformation = data!.main;
            var date =
                DateTime.fromMillisecondsSinceEpoch(data.sys!.sunrise * 1000);
            return Stack(
              children: [
                Image.asset('assets/clouds.jpeg', fit: BoxFit.fill, height: double.infinity,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                    ),
                    Text(
                      data.name,
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SunriseSunset(
                            "Amanecer",
                            new DateTime.fromMillisecondsSinceEpoch(
                                data.sys!.sunrise * 1000),
                            FontAwesomeIcons.sun,
                            Colors.yellow,
                            "AM"),
                        _SunriseSunset(
                            "Puesta de sol",
                            new DateTime.fromMillisecondsSinceEpoch(
                                data.sys!.sunset * 1000),
                            FontAwesomeIcons.moon,
                            Colors.black,
                            "PM"),
                      ],
                    ),
                    _iconNighDay(
                      sunset: DateTime.fromMillisecondsSinceEpoch(
                          data.sys!.sunset * 1000),
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
                            weatherInformation.temp.toString(),
                            style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data.weather[0].description.capitalize(),
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MoreInformation('Min', weatherInformation.tempMin, true),
                          _MoreInformation('Max', weatherInformation.tempMax, true),
                          _MoreInformation(
                              'Act', weatherInformation.feelsLike, true),
                          _MoreInformation(
                              'Hum', weatherInformation.humidity.toDouble(), false),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class _iconNighDay extends StatelessWidget {
  final DateTime sunset;

  const _iconNighDay({required this.sunset});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    
    return ZoomIn(
      child: FaIcon(
        (now.isAfter(sunset))?FontAwesomeIcons.moon:FontAwesomeIcons.sun,
        color: Colors.yellow,
        size: 50,
      ),
    );
  }
}

class _SunriseSunset extends StatelessWidget {
  final String title;
  final DateTime subtitle;
  final IconData icon;
  final Color color;
  final String suffix;

  const _SunriseSunset(@required this.title, @required this.subtitle,
      @required this.icon, @required this.color, @required this.suffix);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(color: Colors.white);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          FaIcon(
            this.icon,
            color: this.color,
          ),
          Text(
            this.title,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Text(
            '${DateFormat.Hms().format(this.subtitle)} ${this.suffix} ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class _MoreInformation extends StatelessWidget {
  final String title;
  final double subtitle;
  final bool isTemperature;

  const _MoreInformation(
      @required this.title, @required this.subtitle, this.isTemperature);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(color: Colors.white);
    return Container(
      height: 45,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(
            this.title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '${this.subtitle}${(isTemperature) ? "°C" : ""}',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }
}
