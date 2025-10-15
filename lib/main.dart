import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tow_management_system_ui/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: !kReleaseMode,
      title: 'Tow Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade400),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
