import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

Widget Loader({
  required BuildContext context,
  required String text,
}) {
  Size size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width,
    height: size.width * 0.3,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
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
          text,
          style: const TextStyle(
            fontSize: 12,
          )
        ).animate().fadeIn(),
      ],
    ),
  );
}