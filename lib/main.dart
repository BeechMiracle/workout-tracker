import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/homepage.dart';

void main() async {
  // initialize Hive
  await Hive.initFlutter();

  // open hive box
  await Hive.openBox('workout_database3');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.purple[50],
              iconTheme: IconThemeData(color: Colors.deepPurple[900]),
            )),
        home: const HomePage(),
      ),
    );
  }
}
