import 'dart:convert';
import 'package:first_ai/data/datasources/authentication/auth_datasource_impl.dart';
import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/presentation/screens/auth/signup.dart';
import 'package:first_ai/presentation/screens/masters/homie.dart';
import 'package:first_ai/presentation/screens/masters/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late var datas;
  late SharedPreferences infos;
  TextEditingController emailController = TextEditingController();
  final LocalAuthentication localAuth = LocalAuthentication();
  late bool? isActive = true;

  clearForm() {
    emailController.text = "";
  }

  updateBtnState() {
    setState(() {
      isActive = !isActive!;
    });
  }

  Future _MyAuthentication() async {

    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: "Pour plus de sécurité, procéder à la vérification",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if(isAuthenticated){
        datas = await Preferences().getUserInfos();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => MapScreen(userInfos: datas)), (route) => false);
      }
    } catch (e) {
      datas = await Preferences().getUserInfos();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => MapScreen(userInfos: datas)), (route) => false);
    }

  }

  Future login() async{
    updateBtnState();
    if(emailController.text.isEmpty){
      setState((){
        updateBtnState();
      });
      Utils().showMsgBox("Veuillez renseigner l'adresse mail", true, context);
    }else{
      Map<String, String> body = {
        "email": emailController.text,
      };
      AuthDataSourceImpl().login(body).then((value) async{
        if(value['error'] == true){
          setState((){
            updateBtnState();
          });
          Utils().showMsgBox(value['message'], true, context);
        }else{
          clearForm();
          setState((){
            updateBtnState();
          });
          Preferences().saveUserInfos(value["data"]['id'], value["data"]['name'], value["data"]['email']);
          await _MyAuthentication();
        }
      });

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Connexion",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )
              ).animate().fadeIn(),
              const SizedBox(height: 30,),
              const Text(
                "Adresse mail",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x1d05b71d),
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
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: isActive! ? ElevatedButton(
                    onPressed: () => login(),
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
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignupScreen()));
                    },
                    child: Text(
                      "S'enroller",
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
            ],
          )
        ),
      )
    );
  }
}
