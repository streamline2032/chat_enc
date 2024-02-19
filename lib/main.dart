import 'package:flutter/material.dart';
import 'package:chat_enc/screens/chat_screen.dart';
import 'package:chat_enc/screens/registration_screen.dart';
import 'package:chat_enc/screens/signin_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBntvOs7QRkOzYteUlro66tLahdowUNJdQ",
      appId: "1:782206365501:android:f05dc9f2d38f6bfd345f54",
      messagingSenderId: "782206365501",
      projectId: "chatencr-7df69",
    ),
  );
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CodeLine',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: ChatScreen(),
        initialRoute: _auth.currentUser != null
            ? ChatScreen.screenRoute
            : HomeScreen.screenRoute,
        routes: {
          HomeScreen.screenRoute: (context) => HomeScreen(),
          SignInScreen.screenRoute: (context) => SignInScreen(),
          RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
          ChatScreen.screenRoute: (context) => ChatScreen(),
        });
  }
}
