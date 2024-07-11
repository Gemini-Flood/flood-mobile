import 'package:first_ai/domain/entities/ai/gemini_prediction.dart';

class GeminiPredictionModel extends GeminiPrediction {

  GeminiPredictionModel({
    required super.prevision,
    required super.prediction,
    required super.historique,
    required super.risque,
    required super.detail,
    required super.recommandation,
    required super.remarque
  });

  factory GeminiPredictionModel.fromJson(Map<String, dynamic> json) {
    return GeminiPredictionModel(
      prevision: json['prevision'],
      prediction: json['prediction'],
      historique: json['historique'],
      risque: json['risque'],
      detail: json['detail'],
      recommandation: json['recommandation'],
      remarque: json['remarque']
    );
  }
}