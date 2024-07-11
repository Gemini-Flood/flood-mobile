import 'package:first_ai/data/models/ai/gemini_prediction.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ResultScreen extends StatefulWidget {
  final GeminiPredictionModel result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  late bool showMore = false;
  late String infos;

  prepareInfos(){
    infos = "";

    infos += "${widget.result.prevision['titre']} \n\n ${widget.result.prevision['message']}";
    infos += "\n\n${widget.result.prediction['titre']} \n\n ${widget.result.prediction['message']}";
    infos += "\n\n${widget.result.historique['titre']} \n\n ${widget.result.historique['message']}";
    infos += "\n\n${widget.result.recommandation['titre']} \n\n ${widget.result.recommandation['message']}";
    infos += "\n\n${widget.result.remarque['titre']} \n\n ${widget.result.remarque['message']}";

    return infos;
  }

  void toggleShowMore() {
    setState(() {
      showMore = !showMore;
    });
  }

  @override
  void initState() {
    prepareInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
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
            padding: EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            selectable: true,
            data: "${widget.result.risque['titre']} \n\n ${widget.result.risque['message']}",
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
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              selectable: true,
              data: infos,
            ).animate().fadeIn()
        ]
      ),
    );
  }
}
