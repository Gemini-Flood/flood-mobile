import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/presentation/screens/auth/login.dart';
import 'package:first_ai/presentation/screens/home.dart';
import 'package:first_ai/presentation/screens/masters/homie.dart';
import 'package:first_ai/presentation/screens/masters/maps.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({super.key});

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {

  getUserDatas() async {
    await Permission.location.request();
    await Future.delayed(const Duration(seconds: 3), () => Preferences().getUserInfos()).then((value) {
      if(value['id'] != null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(userInfos: value)), (route) => false);
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDatas();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // aiLogo(size: 75).animate().fadeIn(),
              Image.asset(
                "assets/vectors/icone.png",
                width: 75,
                height: 75,
                fit: BoxFit.fill,
              ).animate().fadeIn(),
              const SizedBox(height: 5,),
              const Text(
                "FloodAI par Gemini",
                style: TextStyle(
                  fontSize: 12,
                )
              ).animate().fadeIn(),
              const SizedBox(height: 20,)
            ]
        ),
      ),
    );
  }
}
