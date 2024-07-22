import 'dart:io';
import 'package:first_ai/data/models/history.dart';
import 'package:first_ai/presentation/viewmodels/gemini_vm.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class GeminiClient {
  GeminiClient({
    required this.model,
  });

  final GenerativeModel model;

  convertHistory(List<HistoryModel> histories) {
    List<Content> contents = [];
    for(HistoryModel history in histories) {
      if(history.type == "user") {
        contents.add(Content.text(history.message));
      }else{
        contents.add(
          Content.model(
            [TextPart(history.message),]
          )
        );
      }
    }
    return contents;
  }

  Future generateContentFromText({required String prompt}) async {
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text;
  }

  Future haveTalk({required String message, required List<HistoryModel> histories, required BuildContext context}) async {
    var gemini = Provider.of<GeminiViewModel>(context, listen: false);
    String payload = "$message\n\n"
        "Bases toi sur ce guide en JSON pour repondre à la question de l'utilisateur:\n\n"
        "${gemini.guide}\n\n"
        "À part les usages de vivre ensemble, pour toute question qui ne sera pas du contexte de ce guide, "
        "retournes à l'utilisateur que tu ne peux lui répondre vu que le contexte est faussé mais ne mentionnes pas le guide dans les retours.\n";
    final Content prompt = Content.text(payload);

    final contents = await convertHistory(histories);

    final chat = model.startChat(
      history: contents
    );
    final response = await chat.sendMessage(prompt);
    return response.text;
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

