import 'dart:io';
import 'package:first_ai/data/constants.dart';
import 'package:first_ai/data/models/floods/report.dart';
import 'package:first_ai/data/models/floods/zone.dart';
import 'package:first_ai/presentation/screens/masters/homie.dart';
import 'package:first_ai/presentation/screens/pages/floods/report.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:first_ai/presentation/viewmodels/weather_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class MapScreen extends StatefulWidget {
  final userInfos;
  final int type; // 0 = report, 1 = analyze
  final List<ReportModel> reports;
  final List<ZoneModel> zones;
  const MapScreen({super.key, this.userInfos, required this.type, required this.reports, required this.zones});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late bool showMarks = false;
  late GoogleMapController mapController;
  late ScreenshotController screenshotController = ScreenshotController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  retrieveUserPosition() async {
    var googlevm = await Provider.of<GoogleViewModel>(context, listen: false);
    await googlevm.getInitialPosition(true, true);
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

  _showZoneDialog(BuildContext context, ZoneModel zone, Size size, Placemark placemark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Screenshot(
            controller: screenshotController,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/markers/zone.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Risque ${zone.riskLevel}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ).animate().fadeIn(),
                  Divider(color: Theme.of(context).primaryColorLight.withOpacity(0.3)).animate().fadeIn(),
                  SizedBox(height: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enregistré le",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13
                        ),
                      ),
                      Text(
                        DateFormat.yMMMMEEEEd("fr").format(zone.createdAt),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Markdown(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    selectable: true,
                    data: zone.historicalData,
                  )
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                screenshotController.capture().then((var image) async {
                  final _image = image;

                  final dir = await getApplicationDocumentsDirectory();
                  final imagePath = await File('${dir.path}/zone_${zone.id}_${DateTime.now()}.png').create();
                  await imagePath.writeAsBytes(_image!);

                  await Share.shareXFiles(
                    [XFile(imagePath.path)],
                    text: "Prévision de risque d'inondation \n\n"
                        "Risque ${zone.riskLevel}\n"
                        "Veuillez prendre des précautions et vous prévenir d'un potentiel risque d'inondation dans cette zone.\n\n"
                        "Lien de l'adresse sur la carte : https://www.google.com/maps/search/?api=1&query=${zone.latitude},${zone.longitude}"
                  );

                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColorLight),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              ),
              child: Text(
                  "Partager",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                  )
              ),
            ).animate().fadeIn(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Fermer",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold
                ),
              ),
            ).animate().fadeIn(),
          ],
        );
      },
    );
  }

  _showReportDialog(BuildContext context, ReportModel report, Size size, Placemark placemark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Screenshot(
            controller: screenshotController,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/markers/report.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${report.location}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ).animate().fadeIn(),
                  Divider(color: Theme.of(context).primaryColorLight.withOpacity(0.3)).animate().fadeIn(),
                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: size.width * 0.25,
                          height: size.width * 0.25,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(Constants.fileUrl + report.image),
                              fit: BoxFit.cover
                            ),
                          )
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Créé le",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13
                              ),
                            ),
                            Text(
                              DateFormat.yMMMMEEEEd("fr").format(report.createdAt),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text(
                    report.description,
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ).animate().fadeIn()
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                screenshotController.capture().then((var image) async {
                  final _image = image;

                  final dir = await getApplicationDocumentsDirectory();
                  final imagePath = await File('${dir.path}/report_${report.id}_${DateTime.now()}.png').create();
                  await imagePath.writeAsBytes(_image!);

                  final http.Response response = await http.get(Uri.parse(Constants.fileUrl + report.image));
                  final bytes = response.bodyBytes;
                  final file = await File('${dir.path}/reportnetwork_${report.id}_${DateTime.now()}.png').create();
                  await file.writeAsBytes(bytes);

                  await Share.shareXFiles(
                      [
                        XFile(imagePath.path),
                        XFile(file.path)
                      ],
                      text: "Rapport d'inondation \n\n"
                          "Lien de l'adresse sur la carte : https://www.google.com/maps/search/?api=1&query=${report.latitude},${report.longitude}"
                  );

                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColorLight),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              ),
              child: Text(
                  "Partager",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold
                  )
              ),
            ).animate().fadeIn(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Fermer",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold
                ),
              ),
            ).animate().fadeIn(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sélectionner un lieu",
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showMarks = !showMarks;
              });
            },
            icon: Icon(
              showMarks ? Icons.toggle_on_rounded : Icons.toggle_off_outlined,
              color: showMarks ? Theme.of(context).primaryColorLight : Colors.black,
            ),
          ),
        ],
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
                  ),
                  if(widget.type == 0 && showMarks)
                    ...widget.reports.map((report) => Marker(
                      markerId: MarkerId("r${report.id}"),
                      icon: google.customReportIcon!,
                      position: LatLng(double.parse(report.latitude), double.parse(report.longitude)),
                      onTap: () => _showReportDialog(context, report, size, google.getPlacemarks.reversed.last),
                    )),
                  if(widget.type == 1 && showMarks)
                    ...widget.zones.map((zone) => Marker(
                      markerId: MarkerId("z${zone.id}"),
                      icon: google.customZoneIcon!,
                      position: LatLng(double.parse(zone.latitude), double.parse(zone.longitude)),
                      onTap: () => _showZoneDialog(context, zone, size, google.getPlacemarks.reversed.last),
                    )),
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
                        border: Border.all(color: Theme.of(context).primaryColorLight),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              IconButton(
                                onPressed: () => retrieveUserPosition(),
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all(const Size(45, 45)),
                                  elevation: WidgetStateProperty.all(5),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )
                                  ),
                                  backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColorLight.withOpacity(0.8))
                                ),
                                icon: const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 20,
                                )
                              )
                            ],
                          ).animate().fadeIn(),
                          Divider(color: Theme.of(context).primaryColorLight.withOpacity(0.2)),
                          GestureDetector(
                            onTap: () async {
                              var latitude = google.center!.latitude.toString();
                              var longitude = google.center!.longitude.toString();
                              String location = "${google.getPlacemarks.reversed.last.locality}, ${google.getPlacemarks.reversed.last.subLocality!.isNotEmpty ? google.getPlacemarks.reversed.last.subLocality : google.getPlacemarks.reversed.last.administrativeArea}";
                              if(widget.type == 0){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReportScreen(userInfos: widget.userInfos, location: location, latitude: latitude, longitude: longitude,)));
                              }else if(widget.type == 1){
                                await Provider.of<WeatherViewModel>(context, listen: false).setGoogleViewModel(google);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomieScreen(userInfos: widget.userInfos, location: location, latitude: latitude, longitude: longitude)));
                              }
                            },
                            child: Container(
                              height: 45,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Theme.of(context).primaryColorLight.withOpacity(0.4))
                              ),
                              child: Center(
                                child: Text(
                                  widget.type == 0 ? "Reporter une inondation" : "Démarrer une analyse",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ).animate().fadeIn(),
                    Container(
                      width: size.width,
                      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  "assets/markers/pin.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: size.width * 0.17,
                                  child: Text(
                                    "Votre position",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  "assets/markers/report.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: size.width * 0.17,
                                  child: Text(
                                    "Rapports d'inondation",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  "assets/markers/zone.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: size.width * 0.17,
                                  child: Text(
                                    "Prévisions d'inondation",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ).animate().fadeIn(),
                  ],
                ).animate().fadeIn(),
              )
            ],
          );
        }
      ),
    );
  }
}
