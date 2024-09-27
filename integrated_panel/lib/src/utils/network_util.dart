import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  // Checks if the device is connected to the internet
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty;
  }
}