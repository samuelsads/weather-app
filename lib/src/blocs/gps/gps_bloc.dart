import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;
  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isGpsPermissionGrandled)));
    _init();
  }

  Future<void> _init() async {

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGrande()
    ]);

    add(GpsAndPermissionEvent(
        isGpsEnabled: gpsInitStatus[0],
        isGpsPermissionGrandled: gpsInitStatus[1]));
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      print('services status $event');
      final isEnabled = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
          isGpsEnabled: isEnabled,
          isGpsPermissionGrandled: state.isGpsPermissionGranted));
      //TODO: ddisparar eventos
    });

    return isEnabled;
  }

  Future<bool> _isPermissionGrande() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }
  Future<Position> getLocation() async{
    Position position  = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    print(status);
    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        add(GpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGrandled: false));
        openAppSettings();
        break;
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGrandled: true));
        break;
    }
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    // TODO: limpiar el serviceStatus stream
    return super.close();
  }
}
