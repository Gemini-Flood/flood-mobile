import 'package:first_ai/presentation/screens/masters/maps.dart';
import 'package:intl/intl.dart';
import 'package:first_ai/presentation/viewmodels/flood_vm.dart';
import 'package:first_ai/presentation/widgets/loader.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:text_gradiate/text_gradiate.dart';

class HomeScreen extends StatefulWidget {
  final userInfos;
  const HomeScreen({super.key, required this.userInfos});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<FloodViewModel>(
        builder: (context, flood, child) {
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        aiLogo(size: 50).animate().fadeIn(),
                      ],
                    ),
                    TextGradiate(
                      text: Text(
                        "Howdy ${widget.userInfos['name']}...",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      colors: const [
                        Colors.deepPurpleAccent,
                        Colors.redAccent,
                      ],
                      gradientType: GradientType.linear,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      tileMode: TileMode.clamp,
                    ).animate().fadeIn(),
                    const SizedBox(height: 20,),
                    const Text(
                      "Bienvenue sur votre plateforme de prévision d'inondation",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      )
                    ).animate().fadeIn(),
                    const SizedBox(height: 30,),
                    Column(
                      children: [
                        Container(
                          width: size.width,
                          height: size.width * 0.15,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                          ),
                          child: const Center(
                            child: Text(
                              "Choisir une action",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(userInfos: widget.userInfos, type: 0,))),
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.25,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border: Border.all(color: Theme.of(context).primaryColorLight),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                  )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(height: 20,),
                                    Image.asset(
                                      "assets/vectors/report.png",
                                      width: size.width * 0.2,
                                      height: size.width * 0.2,
                                      fit: BoxFit.fill,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColorLight,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(7),
                                        )
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Reporter",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(userInfos: widget.userInfos, type: 1,))),
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.25,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                    border: Border.all(color: Theme.of(context).primaryColorLight),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(height: 20,),
                                    Image.asset(
                                      "assets/vectors/analyze.png",
                                      width: size.width * 0.2,
                                      height: size.width * 0.2,
                                      fit: BoxFit.fill,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColorLight
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Analyser",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.3,
                              height: size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Theme.of(context).primaryColorLight),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(height: 20,),
                                  Image.asset(
                                    "assets/vectors/alert.png",
                                    width: size.width * 0.2,
                                    height: size.width * 0.2,
                                    fit: BoxFit.fill,
                                  ),
                                  Container(
                                    width: size.width * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColorLight,
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(7),
                                      )
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Alerter",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ]
                    ).animate().fadeIn(),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mes rapports",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                          ),
                        ).animate().fadeIn(),
                        GestureDetector(
                          onTap: () => flood.retrieveReport(),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.refresh_rounded,
                              size: 20,
                            ),
                          ),
                        ).animate().fadeIn(),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    if(flood.retrieving)
                      Loader(context: context, text: "Récupération des rapports d'inondation"),
                    if(flood.retrieving == false && flood.getReports.isEmpty)
                      Container(
                        width: size.width,
                        height: size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: const Text(
                            "Aucun rapport d'inondation envoyé",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ).animate().fadeIn(),
                        ),
                      ),
                    if(flood.retrieving == false && flood.getReports.isNotEmpty)
                      ...flood.getReports.reversed.take(3).map((report) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Icon(
                                  Icons.report_outlined,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              SizedBox(
                                width: size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          DateFormat.yMMMMEEEEd('fr_FR').format(report.createdAt),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ).animate().fadeIn(),
                                      ],
                                    ),
                                    Text(
                                      report.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ).animate().fadeIn(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  ],
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
