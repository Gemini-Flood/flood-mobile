import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

class GeminiClient {
  GeminiClient({
    required this.model,
  });

  final GenerativeModel model;

  Future generateContentFromText({required String prompt}) async {
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text;
  }

  Future haveTalk() async {
    final chat = await model.startChat();
    return chat;
  }

  Future generateContentFromImage({required File image, required String message}) async {
    final prompt = TextPart(message);

    var imgBytes = await image.readAsBytes();
    var imageMimeType = lookupMimeType(image.path);

    final imageParts = [
      DataPart(imageMimeType!, imgBytes),
    ];
    final response = await model.generateContent(
      [
        Content.multi([
          prompt,
          ...imageParts
        ])
      ]
    );
    return response.text;
  }
}

