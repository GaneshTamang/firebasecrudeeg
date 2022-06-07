// ignore_for_file: avoid_print

import 'package:crudeeg/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  //binding with widget from firestore and sensuring at start of program
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  //initiazing fire base
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          //if no error return main

          if (snapshot.connectionState == ConnectionState.done) {
            return const MaterialApp(
              home: Homepage(),
            );
          }
          //check snap data has connection error or not
          if (snapshot.hasError) {
            print('something went wrong');
          }
          //if waiting return directly
          return const CircularProgressIndicator();
        });
  }
}
