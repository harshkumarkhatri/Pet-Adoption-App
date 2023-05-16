import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_adoption_app/screens/home_screen.dart';
import 'package:pet_adoption_app/screens/no_connectivity_screen.dart';
import 'package:pet_adoption_app/screens/on_boarding_screen.dart';

class PetApp extends StatefulWidget {
  const PetApp({super.key});

  @override
  State<PetApp> createState() => _PetAppState();
}

class _PetAppState extends State<PetApp> {
  bool? isCarouselDisplayedOnce;
  bool? isConnectionAvailable;
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnectionAvailable = false;
      } else {
        isConnectionAvailable = true;
      }
      setState(() {});
    });
    checkCarouselDisplayed();
  }

  void checkCarouselDisplayed() async {
    var box = await Hive.openBox('carousel_displayed_once');
    if (box.get("carousel_displayed_once") != null) {
      setState(() {
        isCarouselDisplayedOnce = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isConnectionAvailable == null || isConnectionAvailable == false) {
      return const NoConnectivityScreen();
    }
    // Displays until data read from hive
    if (isCarouselDisplayedOnce == null) {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Displays when carousel once seen
    if (isCarouselDisplayedOnce != null && isCarouselDisplayedOnce!) {
      return const HomeScreen();
    }
    // Displays whenapp opened for first time
    return const OnBoarding();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
