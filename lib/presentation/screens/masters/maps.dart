import 'package:first_ai/presentation/screens/masters/homie.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
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
      body: Consumer<GoogleViewModel>(
        builder: (context, google, child) {
          if(google.isLoading){
            return const Progress();
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
              Container(
                width: size.width,
                margin: const EdgeInsets.only(top: kToolbarHeight, left: 10, right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Theme.of(context).primaryColorLight, width: 2),
                ),
                child: Row(
                  children: [
                    aiLogo(size: 50),
                    SizedBox(
                      width: size.width * 0.7,
                      child: const Text(
                          "Choisir un lieu sur la carte pour lancer les analyses...",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    )
                  ],
                ).animate().fadeIn(),
              ).animate().fadeIn(),
              Positioned(
                bottom: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width * 0.75,
                      margin: const EdgeInsets.only(top: kToolbarHeight, left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Theme.of(context).primaryColorLight, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*SizedBox(
                            width: size.width * 0.6,
                            child: const Text(
                                "Vous avez sélectionné",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                )
                            ),
                          ),*/
                          SizedBox(
                            width: size.width * 0.6,
                            child: Text(
                                "${google.getPlacemarks.reversed.last.locality}, ${google.getPlacemarks.reversed.last.subLocality!.isNotEmpty ? google.getPlacemarks.reversed.last.subLocality : google.getPlacemarks.reversed.last.administrativeArea}"   ,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                        ],
                      ).animate().fadeIn(),
                    ).animate().fadeIn(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: () => retrieveUserPosition(),
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(),
                        const SizedBox(height: 10,),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomieScreen(userInfos: widget.userInfos, position: google.position!,)), (route) => false);
                          },
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(),
                      ],
                    )
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
