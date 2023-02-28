import 'dart:async';

import 'package:flutter/cupertino.dart';

class TexteCleanBloc {
  TextEditingController textEditingController = TextEditingController();

  // Sending value to Stream
  final StreamController<TextEditingController> Texteditingclear =
      StreamController<TextEditingController>();

  // Expose value to StreamBuilder
  Stream<TextEditingController> get TexteditingclearStream =>
      Texteditingclear.stream;

  TextClean() {
    textEditingController.clear();
    Texteditingclear.sink.add(textEditingController);
  }

  // decrementCounter() {
  //   Texteditingclear.sink.add(count--);
  // }

  void dispose() {
    Texteditingclear.close();
  }
}
