import 'dart:convert';
import 'dart:io';
import 'package:first_ai/data/helpers/preferences.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/models/ai/gemini_prediction.dart';
import 'package:first_ai/domain/clients/gemini_client.dart';
import 'package:first_ai/presentation/screens/ai/result.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class GeminiViewModel extends ChangeNotifier {

  GeminiViewModel(Map<String, dynamic> guide) {
    setError(false);
    setGuide(guide);
  }

  bool _loading = false;
  bool _error = false;
  String? message;
  GeminiPredictionModel? _prediction;
  Map<String, dynamic> _guide = {};
  List<String> _suggestions = [];

  bool get loading => _loading;
  bool get error => _error;
  String get getMessage => message!;
  GeminiPredictionModel get prediction => _prediction!;
  Map<String, dynamic> get guide => _guide;
  List<String> get suggestions => _suggestions;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setError(bool value) {
    _error = value;
    notifyListeners();
  }

  setMessage(String value) {
    message = value;
    notifyListeners();
  }

  setPrediction(GeminiPredictionModel value) {
    _prediction = value;
    notifyListeners();
  }

  setGuide(Map<String, dynamic> value) {
    _guide = value;
    notifyListeners();
  }

  setSuggestions(List<String> value) {
    _suggestions = value;
    notifyListeners();
  }

  retrievePrediction({
    required BuildContext context,
    required String latitude,
    required String longitude,
    required String location
  }) async {

    setLoading(true);

    var datas = await Preferences().getWeatherInfos();
    Map<String, dynamic> body = {
      "prévisions": json.encode(datas["weather"]),
      "prédiction à venir": json.encode(datas["forecast"]),
      "historique des précipitations": json.encode(datas["locate"]),
      "topographie des coordonnées": json.encode(datas["elevation"]),
    };
    String message = "Analyse les données météorologiques suivantes et extrais les informations importantes pour prédire le risque d'inondation: ${body}\n"
        "Retourne ton analyse en sections avec les titres (en gras obligatoirement) et les messages détaillés. Formatte la réponse en JSON avec les clés suivantes:\n"
        "{\n"
        "  \"prevision\": { \"titre\": \"**Prévision**\", \"message\": \"Analyse des prévisions météorologiques\" },\n"
        "  \"prediction\": { \"titre\": \"**Prédiction**\", \"message\": \"Prédiction du risque d'inondation\" },\n"
        "  \"historique\": { \"titre\": \"**Historique**\", \"message\": \"Analyse des données historiques\" },\n"
        "  \"risque\": { \"titre\": \"**Risque**\", \"message\": \"**Type de risque parmis les types suivants: 'faible', 'modéré', 'élevé', 'extrême', 'crue soudaine'**\" },\n"
        "  \"detail\": { \"titre\": \"**Détail sur le risque**\", \"message\": \"Étude sur le risque actuel\" },\n"
        "  \"recommandation\": { \"titre\": \"**Recommandation**\", \"message\": \"Recommandations pour les utilisateurs\" },\n"
        "  \"remarque\": { \"titre\": \"**Remarque**\", \"message\": \"Remarques supplémentaires\" }\n"
        "}\n"
        "Assure-toi que chaque section est complète, détaillée et que les informations importantes à relever soient en gras suivant les conventions de Markdown.\n";
        "La section du risque doit être précise, concise et brève.\n";


    var gemini = Provider.of<GeminiClient>(context, listen: false);
    await gemini.generateContentFromText(prompt: message).then((value) async {
      String result = value.replaceAll(RegExp(r'```json\n*'), '');
      result = result.replaceAll(RegExp(r'```'), '');

      setPrediction(GeminiPredictionModel.fromJson(json.decode(result)));
      setLoading(false);
      setError(false);
      var infos = await Preferences().getUserInfos();

      Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(userInfos: infos,result: _prediction!, location: location, latitude: latitude, longitude: longitude,)));
    }).onError((e, s) {
      setLoading(false);
      setError(true);
    });

  }

  analyseMedia({
    required BuildContext context,
    required File image
  }) async {

    setLoading(true);

    String message = "Génère une description assez poussée à la base de l'analyse de cette photo en te mettant à la place de l'utilisateur qui remplit le formulaire."
        "Il est surtout important de ne garder que les informations ayant un trait avec l'inondation."
        "Mettre la réponse en français";
    var gemini = Provider.of<GeminiClient>(context, listen: false);
    await gemini.generateContentFromImage(image: image, message: message).then((value) {
      setMessage(value);
      setLoading(false);
      setError(false);
    }).onError((e, s) {
      setLoading(false);
      setError(true);
    });

  }

  suggestTips({
    required BuildContext context
  }) async {

    String message = "Génères moi trois suggestions de questions que l'utilisateur pourra poser pour mieux comprendre le fonctionnement de l'application "
        "en te basant uniquement sur ce guide formaté en JSON.\n"
        "Voici le guide en question:\n\n"
        "$guide\n\n"
        "Formatte la réponse en JSON avec une unique clé 'suggestions' qui retournera une liste de trois questions.\n";
    var gemini = Provider.of<GeminiClient>(context, listen: false);
    await gemini.generateContentFromText(prompt: message).then((value) async {
      String result = value.replaceAll(RegExp(r'```json\n*'), '');
      result = result.replaceAll(RegExp(r'```'), '');

      debugPrint(result);
      setSuggestions(List.from(json.decode(result)['suggestions']));
      setLoading(false);
      setError(false);

    }).onError((e, s) {
      setLoading(false);
      setError(true);
    });
  }

}