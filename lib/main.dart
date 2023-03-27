import 'package:fintechquizapp/controller/authcontroller.dart';
import 'package:fintechquizapp/view/authentication/home/Hompage.dart';
import 'package:fintechquizapp/view/authentication/home/adminui.dart';
import 'package:fintechquizapp/view/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // EasyLoading.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenAuthChanges();
  }

  AuthController authController = Get.put(AuthController());

  @override
  bool isLoggedin = false;
  void listenAuthChanges() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // print('User is currently signed out!');
        // Get.to()
      } else {
        print('User is signed in!');
        isLoggedin = true;
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedin
          ? FirebaseAuth.instance.currentUser?.uid ==
                  "hui40yW7HcPs4ZSEtVi0iu1CQyI2"
              ? AdminScreen()
              : Homepage(authController.quizScores)
          : LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}
