import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sthm/model/locations.dart';
import 'package:geolocator/geolocator.dart';

class UpdateLocationModel extends ChangeNotifier {
  final List<LocationModel> _locations = [];

  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  Completer<GoogleMapController> get googleMapController =>
      _googleMapController;

  UnmodifiableListView<LocationModel> get locations =>
      UnmodifiableListView(_locations);

  void _add(LocationModel locationModel) {
    _locations.add(locationModel);
    notifyListeners();
  }

  Future<void> goToCurrentLocation() async {
    final currentPosition = await _determinePosition();
    _add(LocationModel(
        latLng: LatLng(currentPosition.latitude, currentPosition.longitude)));
    final randomLocation = CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 14.4746,
    );
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(randomLocation));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> goToRandomLocation() async {
    final random = Random();
    double nextDouble(num min, num max) =>
        min + random.nextDouble() * (max - min);

    double randomLat = nextDouble(-90, 90);
    double randomLng = nextDouble(-180, 180);

    _add(LocationModel(latLng: LatLng(randomLat, randomLng)));

    final randomLocation = CameraPosition(
      target: LatLng(randomLat, randomLng),
      zoom: 14.4746,
    );
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(randomLocation));
  }
}
