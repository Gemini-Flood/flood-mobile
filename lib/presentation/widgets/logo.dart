import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget aiLogo({required double size}) {
  return Lottie.asset(
    "assets/jsons/logo.json",
    width: size,
    height: size,
    repeat: true,
  );
}