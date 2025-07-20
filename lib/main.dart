import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth_gate.dart';
import 'auth_service.dart';
import 'account_manager_screen.dart'; // Import the new screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Flutter Firebase App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AccountManagerScreen(), // Set AccountManagerScreen as the home page
      ),
    );
  }
}
