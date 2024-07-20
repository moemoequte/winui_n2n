import 'dart:io';

import 'package:flutter/material.dart';

class EdgeState {
  EdgeState._internal();
  static final EdgeState instance = EdgeState._internal();
  bool isRunning = false;
  Process? process;
  EdgeLogger logger = EdgeLogger();
}

class EdgeLogger with ChangeNotifier {
  List<String> logList = [];

  void addLog(String log) {
    logList.add(log);
    notifyListeners();
  }
}
