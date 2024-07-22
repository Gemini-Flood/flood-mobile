import 'package:first_ai/data/models/history.dart';
import 'package:first_ai/domain/clients/gemini_client.dart';
import 'package:first_ai/presentation/viewmodels/chat_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  final String suggestion;
  const ChatScreen({super.key, required this.suggestion});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late String message;
  bool isResponding = false;
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  List<HistoryModel> histories = [];

  sendMessage(String message, BuildContext context) {
    setState(() {
      isResponding = true;
    });
    histories.add(HistoryModel(type: "user", message: message));
    var gemini = context.read<GeminiClient>();
    gemini.haveTalk(message: message, histories: histories, context: context).then((value) {
      setState(() {
        isResponding = false;
      });
      histories.add(HistoryModel(type: "ai", message: value));
      scrollToBottom();
    });
  }

  scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    histories = chat.getHistories;
    messageController.text = widget.suggestion;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flood IA",
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
                        /*if(history.type == "ai")
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: aiLogo(size: 40),
                          ),*/
                        Container(
                          margin: histories.last == history && isResponding == false ? EdgeInsets.only(bottom: size.height * 0.1) : EdgeInsets.zero,
                          constraints: BoxConstraints(maxWidth: size.width * 0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: history.type == "user" ? Theme.of(context).primaryColorLight : Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: history.type == "user" ? const Radius.circular(20) : Radius.zero,
                              topRight: history.type == "user" ? Radius.zero : const Radius.circular(20),
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                          ),
                          child: history.type == "user" ? Text(
                            history.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: history.type == "user" ? Colors.white : Colors.black
                            ),
                          ) : Markdown(
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
                color: Color(0xffffffff)
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
                              maxHeight: size.height * 0.15
                            ),
                            child: TextFormField(
                              maxLines: null,
                              controller: messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                hintText: "Message",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                )
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if(messageController.text.isNotEmpty) {
                            message = messageController.text;
                            messageController.clear();
                            sendMessage(message, context);
                            scrollToBottom();
                          }
                        },
                        child: Container(
                          width: size.width * 0.15,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
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
                          child: Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.white,
                            size: 20,
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
