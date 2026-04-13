import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'models/unit_of_measure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env.local');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UnitsOfMeasureTestScreen(),
    );
  }
}

class UnitsOfMeasureTestScreen extends StatelessWidget {
  const UnitsOfMeasureTestScreen({super.key});

  CollectionReference<UnitOfMeasure> get _ref =>
      FirebaseFirestore.instance.collection('units_of_measure').withConverter(
            fromFirestore: UnitOfMeasure.fromFirestore,
            toFirestore: (unit, _) => unit.toFirestore(),
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Units of Measure')),
      body: FutureBuilder<QuerySnapshot<UnitOfMeasure>>(
        future: _ref.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No documents found.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final unit = docs[index].data();
              return ListTile(
                leading: Text(unit.code),
                title: Text(unit.name),
                subtitle: Text('ID: ${unit.id}'),
                trailing: Icon(
                  unit.isActive ? Icons.check_circle : Icons.cancel,
                  color: unit.isActive ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
