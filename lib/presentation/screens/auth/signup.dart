import 'package:first_ai/data/datasources/authentication/auth_datasource_impl.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/presentation/screens/auth/login.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late bool? isActive = true;

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  retrieveUserPosition() async {
    var googlevm = await Provider.of<GoogleViewModel>(context, listen: false);
    await googlevm.getInitialPosition(true, false);
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

  clearForm() {
    nameController.text = "";
    emailController.text = "";
  }

  updateBtnState() {
    setState(() {
      isActive = !isActive!;
    });
  }

  Future register(LatLng center) async{
    updateBtnState();
    if(nameController.text.isEmpty || emailController.text.isEmpty){
      setState((){
        updateBtnState();
      });
      Utils().showMsgBox("Tous les champs doivent être remplis", true, context);
    }else{
      Map<String, String> body = {
        "name": nameController.text,
        "email": emailController.text,
        "latitude": center.latitude.toString(),
        "longitude": center.longitude.toString()
      };
      AuthDataSourceImpl().signup(body).then((value) async{
        if(value['error'] == true){
          setState((){
            updateBtnState();
          });
          switch(value['code']){
            case 401:
              return Utils().showMsgBox("Cet email est déjà utilisé", true, context);
            default:
              return Utils().showMsgBox("Erreur lors de l'inscription", true, context);
          }
        }else if(value['code'] == 200){
          clearForm();
          setState((){
            updateBtnState();
          });
          Utils().showMsgBox("Votre compte a bien été créé", false, context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<GoogleViewModel>(
        builder: (context, google, child) {
          if(google.isLoading){
            return Progress(text: "Récupération des coordonnées",);
          }
          return SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  height: size.height,
                  width: size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Créer un compte",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            )
                        ).animate().fadeIn(),
                        const SizedBox(height: 30,),
                        const Text(
                            "Pseudo",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            )
                        ).animate().fadeIn(),
                        const SizedBox(height: 5,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x1d6105b7),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Pseudo",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                fontSize: 14
                            ),
                          ),
                        ).animate().fadeIn(),
                        const SizedBox(height: 15,),
                        const Text(
                            "Adresse mail",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            )
                        ).animate().fadeIn(),
                        const SizedBox(height: 5,),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x1d6105b7),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Adresse email",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                fontSize: 14
                            ),
                          ),
                        ).animate().fadeIn(),
                        const SizedBox(height: 15,),
                        const Text(
                            "Choisir votre adresse domiciliée",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            )
                        ).animate().fadeIn(),
                        const SizedBox(height: 5,),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: size.height * 0.3
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).primaryColorLight),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: GoogleMap(
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
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: IconButton(
                                  onPressed: () => retrieveUserPosition(),
                                  style: ButtonStyle(
                                    fixedSize: const WidgetStatePropertyAll(Size(40, 40)),
                                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColorLight),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      )
                                    )
                                  ),
                                  icon: const Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ).animate().fadeIn(),
                              )
                            ],
                          ),
                        ).animate().fadeIn(),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: isActive! ? ElevatedButton(
                              onPressed: () => register(google.center!),
                              style: ButtonStyle(
                                  fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 50)),
                                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColorLight),
                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      )
                                  )
                              ),
                              child: const Text(
                                "Soumettre",
                                style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17
                                ),
                              )
                          ) : CircularProgressIndicator(color: Theme.of(context).primaryColorLight,),
                        ).animate().fadeIn(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                  "Revenir à la connexion",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Theme.of(context).primaryColorLight,
                                      color: Theme.of(context).primaryColorLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900
                                  )
                              ),
                            ).animate().fadeIn(),
                          ],
                        )
                      ]
                  )
              )
          );
        }
      ),
    );
  }
}
