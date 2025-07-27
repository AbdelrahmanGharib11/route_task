import 'package:flutter/material.dart';
import 'package:selfdep/core/di/service_locator.dart';
import 'package:selfdep/features/home/presentation/screen/home_page.dart';
import 'package:selfdep/features/home/presentation/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {'/photo': (context) => const HomeScreen()},
    );
  }
}
