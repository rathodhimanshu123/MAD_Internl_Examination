import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus { online, offline }

final connectivityProvider = StreamProvider<ConnectionStatus>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    if (results.contains(ConnectivityResult.none)) {
      return ConnectionStatus.offline;
    } else {
      return ConnectionStatus.online;
    }
  });
});
