import 'package:first_ai/data/models/ai/gemini_prediction.dart';
import 'package:first_ai/presentation/viewmodels/flood_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final String location;
  final Position position;
  final GeminiPredictionModel result;
  const ResultScreen({super.key, required this.result, required this.location, required this.position});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  late bool showMore = false;
  late String infos;

  prepareInfos(){
    infos = "";

    infos += "${widget.result.detail['titre']} \n\n ${widget.result.detail['message']}";
    infos += "\n\n\n\n${widget.result.prevision['titre']} \n\n ${widget.result.prevision['message']}";
    infos += "\n\n\n\n${widget.result.prediction['titre']} \n\n ${widget.result.prediction['message']}";
    infos += "\n\n\n\n${widget.result.historique['titre']} \n\n ${widget.result.historique['message']}";
    infos += "\n\n\n\n${widget.result.recommandation['titre']} \n\n ${widget.result.recommandation['message']}";
    infos += "\n\n\n\n${widget.result.remarque['titre']} \n\n ${widget.result.remarque['message']}";

    return infos;
  }

  void toggleShowMore() {
    setState(() {
      showMore = !showMore;
    });
  }

  actualize(BuildContext context) async {
    Map<String, dynamic> body = {
      'location': widget.location,
      'latitude': widget.position.latitude.toString(),
      'longitude': widget.position.longitude.toString(),
      'risk_level': widget.result.risque['message'],
      'historical_data': widget.result.detail['message'],
    };
    final flood = Provider.of<FloodViewModel>(context, listen: false);
    await flood.saveZone(body, context);
  }

  @override
  void initState() {
    prepareInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var flood = context.watch<FloodViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Resultat",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      bottomSheet: flood.loading ?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: LinearProgressIndicator(color: Theme.of(context).primaryColorLight).animate().fadeIn(),
      ).animate().fadeIn()
        :
      ElevatedButton(
        onPressed: () => flood.update ? null : actualize(context),
        style: ButtonStyle(
          backgroundColor: flood.update ? WidgetStateProperty.all(Colors.white) : WidgetStateProperty.all(Theme.of(context).primaryColorLight),
          shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
              )
          ),
          fixedSize: WidgetStateProperty.all(Size(size.width,50)),
        ),
        child: Text(
          flood.update ? "Mis à jour" : "Mettre à jour la zone",
          style: TextStyle(
              color: flood.update ? Theme.of(context).primaryColorLight : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer<FloodViewModel>(
        builder: (context, flood, child){
          return ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                Text(
                  "Il est possible que Gemini fournisse des informations erronées, notamment sur des personnes. Il est crucial de les vérifier avec d'autres sources fiables.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple.shade400
                  ),
                ),
                Row(
                  children: [
                    aiLogo(size: 75),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: size.width * 0.7,
                      child: const Text(
                          "Retour sur analyse des données fournies...",
                          style: TextStyle(
                            fontSize: 12,
                          )
                      ),
                    )
                  ],
                ).animate().fadeIn(),
                Markdown(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  selectable: true,
                  data: "${widget.result.risque['titre']} - ${widget.result.risque['message']}",
                ).animate().fadeIn(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => toggleShowMore(),
                      child: Row(
                        children: [
                          Text(
                            showMore ? "Masquer" : "Voir plus",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Icon(
                              showMore ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                              color: Theme.of(context).primaryColorLight
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(),
                if(showMore)
                  Markdown(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    selectable: true,
                    data: infos,
                  ).animate().fadeIn(),
                SizedBox(height: size.height * 0.05,)
              ]
          );
        },
      ),
    );
  }
}
