import 'package:first_ai/presentation/screens/masters/homie.dart';
import 'package:first_ai/presentation/screens/pages/floods/report.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:first_ai/presentation/viewmodels/weather_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final userInfos;
  const MapScreen({super.key, this.userInfos});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  retrieveUserPosition() async {
    var googlevm = await Provider.of<GoogleViewModel>(context, listen: false);
    await googlevm.getInitialPosition(true);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: googlevm.center!,
          zoom: 17,
        )
      )
    );
  }

  retrieveSelectedPosition(LatLng latLng) async {
    var googlevm = await Provider.of<GoogleViewModel>(context, listen: false);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude
    );
    googlevm.setPlacemarks(placemarks.reversed.last);
    googlevm.setCenter(latLng);
    googlevm.setCurrent(false);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 17,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text(
          "Sélectionner un lieu",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer<GoogleViewModel>(
        builder: (context, google, child) {
          if(google.isLoading){
            return const Progress(text: "Récupération de votre position");
          }
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: google.center!,
                  zoom: 15,
                ),
                onMapCreated: _onMapCreated,
                markers: {
                  Marker(
                    markerId: const MarkerId("1"),
                    icon: google.customIcon == null ? BitmapDescriptor.defaultMarker : google.customIcon!,
                    position: google.center!,
                    draggable: true,
                  )
                },
                zoomControlsEnabled: false,
                onTap: (LatLng latLng) => retrieveSelectedPosition(latLng),
              ).animate().fadeIn(),
              PositionedDirectional(
                width: size.width,
                bottom: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width,
                      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Theme.of(context).primaryColorLight, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*aiLogo(size: 50),
                              const SizedBox(width: 5,),*/
                              SizedBox(
                                width: size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        google.current ? "Votre position actuelle" : "Position sélectionnée",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14
                                        )
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        "${google.getPlacemarks.reversed.last.locality}, ${google.getPlacemarks.reversed.last.subLocality!.isNotEmpty ? google.getPlacemarks.reversed.last.subLocality : google.getPlacemarks.reversed.last.administrativeArea}".toUpperCase(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Theme.of(context).primaryColorLight)
                                ),
                                child: IconButton(
                                  onPressed: () => retrieveUserPosition(),
                                  style: ButtonStyle(
                                    fixedSize: WidgetStateProperty.all(const Size(40, 40)),
                                    elevation: WidgetStateProperty.all(5),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                    ),
                                    backgroundColor: WidgetStateProperty.all(Colors.white)
                                  ),
                                  icon: Icon(
                                    Icons.my_location,
                                    color: Theme.of(context).primaryColorLight,
                                    size: 17,
                                  )
                                ),
                              )
                            ],
                          ).animate().fadeIn(),
                          Divider(color: Theme.of(context).primaryColorLight.withOpacity(0.2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  String location = "${google.getPlacemarks.reversed.last.locality}, ${google.getPlacemarks.reversed.last.subLocality!.isNotEmpty ? google.getPlacemarks.reversed.last.subLocality : google.getPlacemarks.reversed.last.administrativeArea}";
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen(userInfos: widget.userInfos, position: google.position!, location: location, )));
                                },
                                child: Container(
                                  height: 40,
                                  width: size.width * 0.425,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10))
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Reporter une inondation",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String location = "${google.getPlacemarks.reversed.last.locality}, ${google.getPlacemarks.reversed.last.subLocality!.isNotEmpty ? google.getPlacemarks.reversed.last.subLocality : google.getPlacemarks.reversed.last.administrativeArea}";
                                  await Provider.of<WeatherViewModel>(context, listen: false).setGoogleViewModel(google);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomieScreen(userInfos: widget.userInfos, position: google.position!, location: location, )));
                                },
                                child: Container(
                                  height: 40,
                                  width: size.width * 0.425,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Analyser",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ).animate().fadeIn()
                        ],
                      ),
                    ).animate().fadeIn(),
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
