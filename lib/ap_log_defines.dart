
import 'package:flutter/material.dart';

enum APLogLevel {
  Off,
  Info,
  Warning,
  Error,
  Fatal,
}

String apLogLevelName(APLogLevel level) {
  switch (level) {
    case APLogLevel.Info: return 'Info';
    case APLogLevel.Warning: return 'Warning';
    case APLogLevel.Error: return 'Error';
    case APLogLevel.Fatal: return 'Fatal';
    default: return 'Off';
  }
}

Color apLogLevelColor(APLogLevel level) {
  switch (level) {
    case APLogLevel.Info: return Colors.lightGreen;
    case APLogLevel.Warning: return Colors.orangeAccent;
    case APLogLevel.Error: return Colors.pink;
    case APLogLevel.Fatal: return Colors.purpleAccent;
    default: return Colors.black87;
  }
}