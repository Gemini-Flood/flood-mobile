import 'dart:io';

class History {
  final String type, message;
  final File? image;

  const History({required this.type, required this.message, this.image});
}