import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Progress extends StatefulWidget {
  final String text;
  const Progress({super.key, required this.text});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          ).animate().fadeIn(),
          const SizedBox(height: 10,),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            )
          ).animate().fadeIn(),
        ],
      ),
    );
  }
}
