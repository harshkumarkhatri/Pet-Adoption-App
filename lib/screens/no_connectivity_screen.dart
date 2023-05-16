import 'package:flutter/material.dart';

class NoConnectivityScreen extends StatefulWidget {
  const NoConnectivityScreen({super.key});

  @override
  State<NoConnectivityScreen> createState() => _NoConnectivityScreenState();
}

class _NoConnectivityScreenState extends State<NoConnectivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/no_internet.jpeg",
            ),
            const Text(
              "Ooops!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "No Internet Connection found",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "Check your connection",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Connecting to internet will auto refresh the feed for you.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
