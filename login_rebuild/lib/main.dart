import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart'; // no problem if not used
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  Future writeCache({required String key, required String value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    bool isSaved = await pref.setString(key, value);

    debugPrint(isSaved.toString());
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Text(
          'Welcome 👋',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
    );
  }
}

// shared prefences example:https://www.youtube.com/watch?v=NBbQ0A03l4w
// source: class MyApp stateless Widget: https://www.youtube.com/watch?v=wE7khGHVkYY
// stateful widget example: https://www.youtube.com/watch?v=AqCMFXEmf3w
