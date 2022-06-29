import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do in 2022'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Wystąpił nieoczekiwany problem');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Proszę czekać trwa ładowanie danych");
            }

            final documents = snapshot.data!.docs;

            return ListView(
              children: [
                CategoryWidget(documents[0]['title']),
                CategoryWidget(documents[1]['title']),
                CategoryWidget('Kategoria 3'),
              ],
            );
          }),
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
      color: Colors.orange.shade700,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      child: Text(title),
    );
  }
}
