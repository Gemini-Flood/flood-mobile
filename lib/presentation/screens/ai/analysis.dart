import 'dart:io';

import 'package:first_ai/data/models/history.dart';
import 'package:first_ai/domain/clients/gemini_client.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {

  final ImagePicker _picker = ImagePicker();
  XFile? _images;
  late String message;
  late File? image = null;
  late File? requestImage = null;
  bool isResponding = false;
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  List<HistoryModel> histories = [];

  Future getImagesFromGallery() async {
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(_image!.path);
    });
  }

  sendMessage(String message, File image) {
    setState(() {
      isResponding = true;
    });
    histories.add(HistoryModel(type: "user", message: message, image: image));
    var gemini = context.read<GeminiClient>();
    if(histories.length == 1) {

    }else{

    }
    gemini.generateContentFromImage(image: image, message: message).then((value) {
      setState(() {
        isResponding = false;
      });
      histories.add(HistoryModel(type: "ai", message: value));
      scrollToBottom();
    });
  }

  scrollToBottom() {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut
    );
  }

  @override
  void initState() {
    messageController.text = "Fais de ton mieux pour me donner une analyse complète et informative de cette photo";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analyse d'image",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: [
              if(histories.isNotEmpty)
                ...histories.map((history) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: history.type == "user" ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if(history.type == "ai")
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: aiLogo(size: 40),
                              ),
                            Container(
                              margin: histories.last == history && isResponding == false ? EdgeInsets.only(bottom: size.height * 0.1) : EdgeInsets.zero,
                              constraints: BoxConstraints(maxWidth: size.width * 0.7),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: history.type == "user" ? Colors.deepPurpleAccent : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: history.type == "user" ? const Radius.circular(10) : Radius.zero,
                                  topRight: history.type == "user" ? Radius.zero : const Radius.circular(10),
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: const Radius.circular(10),
                                ),
                              ),
                              child: history.type == "user" ?
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.file(
                                          history.image!,
                                          fit: BoxFit.contain,
                                          width: size.width * 0.3,
                                          height: size.width * 0.3,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      history.message,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: history.type == "user" ? Colors.white : Colors.black
                                      ),
                                    ),
                                  ],
                                )
                                  : Markdown(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                selectable: true,
                                data: history.message,
                              ),
                            )
                          ]
                      )
                  );
                })
              else
                SizedBox(height: size.height,),
              if(isResponding == true)
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                  child: Row(
                    children: [
                      aiLogo(size: 40),
                      const SizedBox(width: 5,),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 20,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(300),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  color: Color(0xfffff8ff)
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 0.5), // changes position of shadow
                              ),
                            ]
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: image != null ? size.height * 0.3 : size.height * 0.15
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if(image != null)
                                  Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 15),
                                        width: size.width * 0.7,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      image = null;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Image.file(
                                                  image!,
                                                  fit: BoxFit.cover,
                                                  width: size.width * 0.32,
                                                  height: size.width * 0.32,
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                TextFormField(
                                  maxLines: null,
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    hintText: "Message",
                                    hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    suffixIcon: GestureDetector(
                                        onTap: () async {
                                          getImagesFromGallery();
                                        },
                                        child: const Icon(
                                          CupertinoIcons.photo_fill,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      ),
                                    constraints: BoxConstraints(
                                      maxHeight: size.height * 0.1
                                    )
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(messageController.text.isNotEmpty && image != null) {
                            requestImage = image;
                            message = messageController.text;
                            messageController.clear();
                            setState(() {
                              image = null;
                            });
                            sendMessage(message, requestImage!);
                          }
                        },
                        child: Container(
                          width: size.width * 0.15,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0.5), // changes position of shadow
                                ),
                              ]
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.paperplane_fill,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: size.width * 0.9,
                    child: Text(
                      "Il est possible que Gemini fournisse des informations erronées, notamment sur des personnes. Il est crucial de les recouper avec d'autres sources fiables.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.purple.shade400
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
