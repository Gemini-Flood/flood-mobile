import 'dart:convert';
import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/data/models/ai/gemini_prediction.dart';
import 'package:first_ai/domain/clients/gemini_client.dart';
import 'package:first_ai/presentation/screens/ai/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeminiViewModel extends ChangeNotifier {

  bool _loading = false;
  GeminiPredictionModel? _prediction;

  bool get loading => _loading;
  GeminiPredictionModel get prediction => _prediction!;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setPrediction(GeminiPredictionModel value) {
    _prediction = value;
    notifyListeners();
  }

  retrievePrediction(BuildContext context) async {

    setLoading(true);

    var datas = await Preferences().getWeatherInfos();
    Map<String, dynamic> body = {
      "prévisions": json.encode(datas["weather"]),
      "prédiction": json.encode(datas["forecast"]),
      "historique": json.encode(datas["locate"]),
      "topographie des coordonnées": json.encode(datas["elevation"]),
    };
    String message = "Analyse les données météorologiques suivantes et extrais les informations importantes pour prédire le risque d'inondation: ${body}\n"
        "Retourne ton analyse en sections avec les titres (en gras obligatoirement) et les messages détaillés. Formatte la réponse en JSON avec les clés suivantes:\n"
        "{\n"
        "  \"prevision\": { \"titre\": \"**Prévision**\", \"message\": \"Analyse des prévisions météorologiques\" },\n"
        "  \"prediction\": { \"titre\": \"**Prédiction**\", \"message\": \"Prédiction du risque d'inondation\" },\n"
        "  \"historique\": { \"titre\": \"**Historique**\", \"message\": \"Analyse des données historiques\" },\n"
        "  \"risque\": { \"titre\": \"**Risque**\", \"message\": \"**Type bref de risque actuel**\" },\n"
        "  \"detail\": { \"titre\": \"**Détail sur le risque**\", \"message\": \"Étude sur le risque actuel\" },\n"
        "  \"recommandation\": { \"titre\": \"**Recommandation**\", \"message\": \"Recommandations pour les utilisateurs\" },\n"
        "  \"remarque\": { \"titre\": \"**Remarque**\", \"message\": \"Remarques supplémentaires\" }\n"
        "}\n"
        "Assure-toi que chaque section est complète, détaillée et que les informations importantes à relever soient en gras suivant les conventions de Markdown.\n";
        "La section du risque doit être précise, concise et brève.\n";
        "Les types de risques possibles sont : 'Risque faible', 'Risque modéré', 'Risque élevé', 'Risque extrême', 'Risque de crue soudaine'";


    var gemini = Provider.of<GeminiClient>(context, listen: false);
    final value = await gemini.generateContentFromText(prompt: message);

    String result = value.replaceAll(RegExp(r'```json\n*'), '');
    result = result.replaceAll(RegExp(r'```'), '');

    setPrediction(GeminiPredictionModel.fromJson(json.decode(result)));

    setLoading(false);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(result: _prediction!)));
  }

}