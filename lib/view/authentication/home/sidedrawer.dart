import 'package:fintechquizapp/controller/authcontroller.dart';
import 'package:fintechquizapp/view/authentication/home/quizpage.dart';
import 'package:fintechquizapp/view/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class sideDrawer extends StatelessWidget {
  sideDrawer({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            // ignore: sort_child_properties_last
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 300,
                    child: Center(
                      child: Text(
                        user.email.toString()[0].toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff33691E),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.email.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xff009688),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Start New Quiz'),
              onTap: () {
                Get.to(QuizScreen());
              }),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async => {
              EasyLoading.show(status: 'Logging out'),
              FirebaseAuth.instance.currentUser?.displayName != null
                  ? await authController.googleSignIn.disconnect()
                  : Container(),
              FirebaseAuth.instance.signOut(),
              Get.to(LoginScreen()),
              EasyLoading.dismiss(),
            },
          ),
        ],
      ),
    );
  }
}
