import 'package:cognitive_app/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => GameProvider(),
        child: MaterialApp(
          title: 'Flutter Cognitive Memory Game',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        ));
  }
}
