// lib/src/utils/logger.dart
import 'dart:developer';

class Logger {
  static bool _isEnabled = false;
  static bool _isMockMode = false;
  static void enableLogging([bool enable = false]) {
    _isEnabled = enable;
  }

   static void enableMockMode([bool enable = false]) {
    _isMockMode = enable;
  }

  static bool isMockMode(){
    return _isMockMode;
  }
  static void sdklog({required String logtype,required String message,StackTrace? stackTrace}){
    if (_isEnabled) {
      log("$logtype $message",stackTrace:stackTrace);
    }
  }

  static void info(String message) {
      sdklog(logtype:  '[SDK INFO]',message:  message);
  }

  static void debug(String message) {
    sdklog(logtype:  '[SDK DUBUG]',message:  message);
  }


  static void error(String message,StackTrace? stackTrace) {
    sdklog(logtype:  '[SDK ERROR]',message:  message,stackTrace: stackTrace);
  }
}
