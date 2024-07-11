import 'package:first_ai/presentation/viewmodels/gemini_vm.dart';
import 'package:first_ai/presentation/viewmodels/weather_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomieScreen extends StatefulWidget {
  final userInfos;
  final Position position;
  const HomieScreen({super.key, required this.userInfos, required this.position});

  @override
  State<HomieScreen> createState() => _HomieScreenState();
}

class _HomieScreenState extends State<HomieScreen> {

  late bool promptSent = false;
  late bool isLoading = false;

  actualize() async {
    isLoading = true;
    await Provider.of<WeatherViewModel>(context, listen: false).retrieveWeatherDatas(update: true, position:  widget.position);
    promptSent = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer2<WeatherViewModel, GeminiViewModel>(builder: (context, weather, gemini, child) {
        if(weather.loading){
          return const Progress();
        }

        if(weather.error){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Erreur lors du chargement des données", overflow: TextOverflow.ellipsis),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => actualize(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  ),
                  child: const Text(
                    "Actualiser",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        }

        if(weather.loading == false && !promptSent){
          promptSent = true;
          Future.delayed(const Duration(seconds: 5), () => gemini.retrievePrediction(context));
        }

        return SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    weather.getBackground,
                  ),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.softLight)
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.getWeatherData.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ).animate().fadeIn(),
                    const SizedBox(height: 10,),
                    Text(
                      "${weather.getWeatherData.main.temp.toInt()}°",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 175,
                          fontWeight: FontWeight.bold
                      ),
                    ).animate().fadeIn(),
                  ],
                ),
                if(gemini.loading == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Theme.of(context).primaryColorLight, width: 2)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            aiLogo(size: 50),
                            const SizedBox(width: 5,),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 20,
                                width: size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(300),
                                ),
                              ),
                            )
                          ],
                        ).animate().fadeIn(),
                        const SizedBox(height: 5,),
                        const Text(
                            "Analyse du risque d'inondation à partir des données météorologiques récupérées...",
                            style: TextStyle(
                              fontSize: 12,
                            )
                        ).animate().fadeIn(),
                      ],
                    ),
                  ).animate().fadeIn(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IntrinsicHeight(
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Humidité",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ).animate().fadeIn(),
                                const SizedBox(height: 10,),
                                Text(
                                  "${weather.getWeatherData.main.humidity.toInt()} %",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ).animate().fadeIn(),
                              ],
                            ),
                            const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.white,)
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Visibilité",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ).animate().fadeIn(),
                                const SizedBox(height: 10,),
                                Text(
                                  "${weather.getWeatherData.visibility ~/ 1000} km",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ).animate().fadeIn(),
                              ],
                            ),
                            const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.white,)
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Vitesse du vent",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ).animate().fadeIn(),
                                const SizedBox(height: 10,),
                                Text(
                                  "${(weather.getWeatherData.wind.speed * 3.6).toInt()} km/h",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ).animate().fadeIn(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(),
                    if(gemini.loading == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(weather.update)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                "Rechargement des données...",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () => actualize(),
                            child: aiLogo(size: 75).animate().fadeIn(),
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(),
        );
      })
      /*FutureBuilder(
        future: _future,
        builder: (context, snapshot) {


          if(snapshot.connectionState == ConnectionState.done){

            if(!snapshot.hasData){
              return const Progress();
            }
          }

          if(snapshot.hasData){
            if (cachedWeatherData != null && !promptSent) {
              promptSent = true;
              Future.delayed(const Duration(seconds: 5), () => sendPrompt());
            }
          }


        },
      ),*/
    );
  }
}
