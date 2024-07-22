import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:first_ai/presentation/viewmodels/alert_vm.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AlertListScreen extends StatefulWidget {
  final userInfos;
  const AlertListScreen({super.key, this.userInfos});

  @override
  State<AlertListScreen> createState() => _AlertListScreenState();
}

class _AlertListScreenState extends State<AlertListScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Alertes créées",
          style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer<AlertViewModel>(
        builder: (context, alert, child) {
          if(alert.loading){
            return const Progress(text: "Récupération des alertes actives",);
          }

          if(alert.alerts.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Pas d'alertes actives", overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: [
              ...alert.alerts.reversed.map((a) {
                bool show = alert.isExpanded(a.id);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.security_update_warning_rounded,
                              size: 20,
                            ),
                          ).animate().fadeIn(),
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${a.title} - ${a.riskLevel}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ).animate().fadeIn(),
                                Text(
                                  DateFormat.yMMMMEEEEd('fr_FR').format(a.createdAt),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ).animate().fadeIn(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: () {
                              alert.updateExpandedStates(a.id);
                            },
                            child: Icon(
                              show ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 20,
                            ).animate().fadeIn(),
                          )
                        ],
                      ),
                      if(show)
                        Container(
                          width: size.width,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 45,),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a.message,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ).animate().fadeIn(),
                                        Divider(color: Colors.white).animate().fadeIn(),
                                        Markdown(
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          selectable: true,
                                          data: a.zone.historicalData,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              if(alert.request)
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 20,
                                    width: size.width * 0.87,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(300),
                                    ),
                                  ),
                                ).animate().fadeIn()
                              else
                                GestureDetector(
                                onTap: () {
                                  alert.launchAlert(a.id.toString(), context);
                                },
                                child: Container(
                                  height: 40,
                                  width: size.width * 0.87,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColorLight,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Relancer l'alerte",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(),
                            ],
                          ),
                        )
                    ],
                  ),
                );
              })
            ],
          );
        }
      ),
    );
  }
}
