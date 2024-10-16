



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  bool _hasInternetAccess = true;
  late StreamSubscription<ConnectivityResult> _subscription;

  bool get isConnected => _isConnected;
  bool get hasInternetAccess => _hasInternetAccess;

  ConnectivityProvider() {
    _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectivity);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _isConnected = (connectivityResult != ConnectivityResult.none);
    notifyListeners();
    _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    try {
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5));
      if (result.statusCode == 200) {
        _hasInternetAccess = true;
      } else {
        _hasInternetAccess = false;
      }
    } catch (e) {
      _hasInternetAccess = false;
    }
    notifyListeners();
  }

  void _updateConnectivity(ConnectivityResult result) {
    _isConnected = (result != ConnectivityResult.none);
    notifyListeners();
    _checkInternetAccess();
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
