import 'package:first_ai/presentation/screens/ai/chat.dart';
import 'package:first_ai/presentation/screens/home.dart';
import 'package:first_ai/presentation/viewmodels/gemini_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:first_ai/presentation/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class AIPreviewScreen extends StatefulWidget {
  final userInfos;
  const AIPreviewScreen({super.key, required this.userInfos});

  @override
  State<AIPreviewScreen> createState() => _AIPreviewScreenState();
}

class _AIPreviewScreenState extends State<AIPreviewScreen> {

  late bool sendPrompt = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<GeminiViewModel>(
        builder: (context, gemini, child) {
          if(gemini.guide != {} && sendPrompt == false) {
            Future.delayed(Duration(milliseconds: 4000), () {
              sendPrompt = true;
              gemini.suggestTips(context: context);
            });
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width,
                  child: aiLogo(size: size.width * 0.5).animate().fadeIn(
                    delay: Duration(milliseconds: 900),
                    duration: Duration(milliseconds: 900),
                  ).slideY(
                    delay: Duration(milliseconds: 750),
                    duration: Duration(milliseconds: 900),
                    begin: 1,
                    end: 0
                  ),
                ),
                SizedBox(
                  width: size.width,
                  child: Text(
                    "Bienvenue ${widget.userInfos['name']},",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(
                    delay: Duration(milliseconds: 1250),
                    duration: Duration(milliseconds: 1250),
                  ).slideY(
                    delay: Duration(milliseconds: 1000),
                    duration: Duration(milliseconds: 1250),
                    begin: 1,
                    end: 0
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: size.width,
                  child: Text(
                    "Je suis l'assistant intelligent embarqué basé sur Gemini,\n votre guide interactif pour utiliser au mieux ce service.",
                    style: const TextStyle(
                      fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(
                    delay: Duration(milliseconds: 1650),
                    duration: Duration(milliseconds: 1650),
                  ).slideY(
                    delay: Duration(milliseconds: 1400),
                    duration: Duration(milliseconds: 1650),
                    begin: 1,
                    end: 0
                  ),
                ),
                SizedBox(height: 50,),
                if(gemini.suggestions.isNotEmpty)
                  ...gemini.suggestions.map((suggestion) {
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(suggestion: suggestion))),
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).primaryColorLight.withOpacity(0.3))
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: Theme.of(context).primaryColorLight,
                              size: 25,
                            ),
                            SizedBox(width: 10,),
                            SizedBox(
                              width: size.width * 0.75,
                              child: Text(
                                suggestion,
                                style: const TextStyle(
                                  fontSize: 14
                                ),
                              ),
                            )
                          ],
                        )
                      ).animate().fadeIn(
                        delay: Duration(milliseconds: 750),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                  }),
                if(gemini.suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: size.width,
                      child: Text(
                        "Voici quelques suggestions pour commencer",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(
                        delay: Duration(milliseconds: 1250),
                        duration: Duration(milliseconds: 1250),
                      ).slideY(
                          delay: Duration(milliseconds: 1000),
                          duration: Duration(milliseconds: 1250),
                          begin: 1,
                          end: 0
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      ),
    );
  }
}
