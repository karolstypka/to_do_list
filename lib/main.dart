import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/features/auth/pages/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AuthGate(),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 370,
      color: Colors.orange.shade700,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      child: Center(child: Text(title)),
    );
  }
}
