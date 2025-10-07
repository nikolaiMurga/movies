import 'dart:io';

import 'package:flutter/material.dart';

class LogService {
  static LogService? _instance;

  LogService._privateConstructor();

  factory LogService() {
    _instance ??= LogService._privateConstructor();
    return _instance!;
  }

  static List<String> logs = [];

  static addLog(String l) {
    logs.add(l);
    Platform.isIOS ? debugPrint('--==>> ${l.toLowerCase()}') : debugPrint('\x1B[32m --==>> ${l.toLowerCase()}\x1B[0m');
    // Platform.isIOS ? debugPrint('+++<<< ------------------- >>>+++') : debugPrint('\x1B[32m +++<<< ------------------ >>>+++\x1B[0m');
  }

  static printLogs() {
    for (String s in logs) {
      debugPrint(s);
    }
  }
}