import 'package:first_ai/data/helpers/permissions.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleViewModel extends ChangeNotifier {

  GoogleViewModel() {
    getInitialPosition(false, true);
  }

  bool _isLoading = false;
  bool _update = false;
  bool _current = false;
  Position? _position;
  List<Placemark> _placemarks = [];
  LatLng? _center;
  BitmapDescriptor? customIcon;

  bool get isLoading => _isLoading;
  bool get update => _update;
  bool get current => _current;
  Position? get position => _position;
  List<Placemark> get getPlacemarks => _placemarks;
  LatLng? get center => _center;
  BitmapDescriptor? get getCustomIcon => customIcon;

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setCurrent(bool value) {
    _current = value;
    notifyListeners();
  }

  setUpdate(bool value) {
    _update = value;
    notifyListeners();
  }

  setPosition(Position value) {
    _position = value;
    notifyListeners();
  }

  setPlacemarks(Placemark value) {
    _placemarks = [value];
    notifyListeners();
  }

  setCenter(LatLng value) {
    _center = value;
    notifyListeners();
  }

  void setCustomIcons() async {
    customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 2.0),
      'assets/markers/pin.png',
      width: 40,
      height: 40
    );
    notifyListeners();
  }

  getLocation() {
    final LatLng center = LatLng(
        position!.latitude,
        position!.longitude
    );
    return center;
  }

  getInitialPosition(bool update, bool place) async {
    update ? setUpdate(true) : setLoading(true);
    Position position = await Permissions().getPosition();
    if(place){
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );
      setPlacemarks(placemarks.reversed.last);
    }
    final LatLng center = LatLng(
        position.latitude,
        position.longitude
    );
    setCurrent(true);
    setPosition(position);
    setCenter(center);
    setCustomIcons();
    update ? setUpdate(false) : setLoading(false);
  }

}