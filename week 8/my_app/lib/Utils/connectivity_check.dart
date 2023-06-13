import 'package:flutter/material.dart';


import 'package:connectivity_plus/connectivity_plus.dart';
class InternetConnection {
  Widget connectivity(BuildContext context, Widget wg) {
   Connectivity intC= Connectivity();
    return StreamBuilder(
      stream: intC.onConnectivityChanged,
      builder: (context, snapshot) {
        return wg;
      },
    );
  }
}
