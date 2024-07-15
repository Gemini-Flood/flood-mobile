import 'dart:io';

import 'package:first_ai/presentation/viewmodels/flood_vm.dart';
import 'package:first_ai/presentation/viewmodels/gemini_vm.dart';
import 'package:first_ai/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ReportScreen extends StatefulWidget {
  final userInfos;
  final String location;
  final Position position;
  const ReportScreen({super.key, this.userInfos, required this.location, required this.position});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  File? media = null;
  late XFile? _image;
  late bool promptSent = false;
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionController = TextEditingController();

  Future getImageFromGallery() async {
    _image = await _picker.pickImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    setState(() {
      media = File(_image!.path);
    });
  }

  save(BuildContext context) async {
    Map<String, String> body = {
      'user_id': widget.userInfos['id'],
      'description': descriptionController.text,
      'photo': media.toString(),
      'location': widget.location,
      'latitude': widget.position.latitude.toString(),
      'longitude': widget.position.longitude.toString(),
    };
    final flood = Provider.of<FloodViewModel>(context, listen: false);
    await flood.saveReport(body, media!.path, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Reporter une inondation",
          style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer2<FloodViewModel, GeminiViewModel>(
        builder: (context, flood, gemini, child) {

          if(media != null && !promptSent){
            promptSent = true;
            Future.delayed(const Duration(seconds: 1), () => gemini.analyseMedia(context: context, image: media!));
          }

          if(gemini.message != null){
            descriptionController.text = gemini.message!;
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: [
              if(media == null)
                GestureDetector(
                  onTap: () => getImageFromGallery(),
                  child: Container(
                    width: size.width,
                    height: size.width * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(
                      child: Text(
                        "Sélectionner une image",
                        style: TextStyle(
                            fontSize: 13
                        ),
                      ),
                    ),
                  ).animate().fadeIn(),
                )
              else if(media != null)
                Container(
                    width: size.width,
                    height: size.width * 0.3,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: size.width * 0.27,
                                height: size.width * 0.27,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: GlobalThemeData.lightColorScheme.primaryContainer, width: 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: FileImage(media!),
                                      fit: BoxFit.cover
                                  ),
                                )
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              width: size.width * 0.5,
                              child: const Text(
                                "Media selectionné",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13
                                ),
                              ),
                            )

                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              promptSent = false;
                              media = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20,
                          ),
                        )
                      ],
                    )
                ).animate().fadeIn(),
              const SizedBox(height: 20,),

              if(gemini.loading == true)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Theme.of(context).primaryColorLight, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              aiLogo(size: 50),
                              const SizedBox(width: 5,),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 20,
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(300),
                                  ),
                                ),
                              )
                            ],
                          ).animate().fadeIn(),
                          const SizedBox(height: 5,),
                          const Text(
                              "Génération d'une description en lien avec la photo choisie...",
                              style: TextStyle(
                                fontSize: 12,
                              )
                          ).animate().fadeIn(),
                        ],
                      ),
                    ).animate().fadeIn(),
                    const SizedBox(height: 20,),
                  ],
                ),

              if(gemini.error == true)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Theme.of(context).primaryColorLight, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              aiLogo(size: 50),
                              const SizedBox(width: 5,),
                              SizedBox(
                                width: size.width * 0.7,
                                child: const Text(
                                    "Une erreur est survenue lors de la génération",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              )
                            ],
                          ).animate().fadeIn(),
                          const SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () {
                              promptSent = true;
                              gemini.analyseMedia(context: context, image: media!);
                            },
                            child: Container(
                              height: 40,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: const Center(
                                child: Text(
                                  "Relancer",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ).animate().fadeIn(),
                    const SizedBox(height: 20,),
                  ],
                ),

              const Text(
                  "Détail",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  )
              ).animate().fadeIn(),
              const SizedBox(height: 5,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: descriptionController,
                maxLines: 15,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x1d6105b7),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Informations sur l'inondation",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                      fontSize: 14
                  ),
                ),
              ).animate().fadeIn(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: flood.loading == false ? ElevatedButton(
                    onPressed: () => save(context),
                    style: ButtonStyle(
                        fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 50)),
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColorLight),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                        )
                    ),
                    child: const Text(
                      "Soumettre",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 17
                      ),
                    )
                ) : Row(
                  children: [
                    CircularProgressIndicator(color: Theme.of(context).primaryColorLight,),
                  ],
                ),
              ).animate().fadeIn(),
            ],
          );
        }
      ),
    );
  }
}
