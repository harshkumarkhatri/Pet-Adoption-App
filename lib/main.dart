import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_adoption_app/pet_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await Firebase.initializeApp();
  await Hive.initFlutter('hive');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> initHive() async {
  await Hive.initFlutter('hive');
  await Hive.openBox('pet-app');

  var box = await Hive.openBox('adopted_pets');
  if (box.get("adopted_pets") == null) {
    box.put('adopted_pets', []);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption',
      theme: ThemeData(
        brightness: WidgetsBinding.instance.window.platformBrightness ==
                Brightness.light
            ? Brightness.light
            : Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const PetApp(),
    );
  }
}
