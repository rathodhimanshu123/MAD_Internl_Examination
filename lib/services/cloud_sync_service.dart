import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'local_db_service.dart';

class CloudSyncService {
  final LocalDatabaseService _db = LocalDatabaseService.instance;
  StreamSubscription? _connectivitySubscription;

  void startSyncWorker() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        _processOfflineQueue();
      }
    });
  }

  Future<void> _processOfflineQueue() async {
    final commands = await _db.getUnprocessedCommands();
    if (commands.isEmpty) return;

    print('Processing ${commands.length} offline commands...');

    for (var cmd in commands) {
      try {
        // Here you would send cmd['data'] to Firebase Firestore
        // e.g. await FirebaseFirestore.instance.collection('tasks').add(cmd['data']);
        
        // Simulating network delay
        await Future.delayed(const Duration(milliseconds: 500));
        
        await _db.markCommandProcessed(cmd['id']);
        print('Command ${cmd['id']} synced to cloud.');
      } catch (e) {
        print('Sync error for command ${cmd['id']}: $e');
      }
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
