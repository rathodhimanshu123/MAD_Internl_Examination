import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/auth_screen.dart';
import 'utils/theme.dart';
import 'services/cloud_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Start Sync Worker
  final syncService = CloudSyncService();
  syncService.startSyncWorker();
  
  runApp(
    const ProviderScope(
      child: TaskFlowApp(),
    ),
  );
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow Solutions',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
