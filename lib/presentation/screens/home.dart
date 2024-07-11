import 'package:first_ai/presentation/screens/ai/analysis.dart';
import 'package:first_ai/presentation/screens/ai/chat.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:text_gradiate/text_gradiate.dart';

class HomeScreen extends StatefulWidget {
  final userInfos;
  const HomeScreen({super.key, required this.userInfos});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> widgets = [
    const ChatScreen(),
    const AnalysisScreen(),
  ];

  List<IconData> icons = [
    CupertinoIcons.question,
    CupertinoIcons.photo
  ];

  List<String> features = [
    "Questionner Gemini",
    "Analyser des images"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextGradiate(
                  text: const Text(
                    "Howdy Guest...",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  colors: [
                    Colors.deepPurpleAccent,
                    Colors.red,
                  ],
                  gradientType: GradientType.linear,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp,
                ).animate().fadeIn(),
                Text(
                  "En quoi puis-je vous aider aujourd'hui ?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ).animate().fadeIn(),
              ],
            ),
            SizedBox(height: size.height * 0.1,),
            ...features.map((feature) => InkWell(
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => widgets[features.indexOf(feature)])),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icons[features.indexOf(feature)], color: Colors.black87, size: 20,),
                        SizedBox(width: 10,),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Text(
                            feature
                          ),
                        )
                      ],
                    ),
                    Icon(CupertinoIcons.chevron_forward, color: Colors.black87, size: 20,),
                  ],
                ),
              ),
            ))

            /*GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                ...features.map((feature) => GestureDetector(
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => widgets[features.indexOf(feature)])),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 3
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(icons[features.indexOf(feature)], color: Colors.deepPurpleAccent, size: 30,),
                          ],
                        ),
                        Text(
                          feature
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                )).toList()
              ],
            )*/
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {

        },
        child: aiLogo(size: 75).animate().fadeIn(),
      ),
    );
  }
}
