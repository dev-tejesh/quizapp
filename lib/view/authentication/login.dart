import 'package:fintechquizapp/controller/authcontroller.dart';
import 'package:fintechquizapp/view/authentication/phone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authController) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/img1.png',
                    width: 150,
                    height: 150,
                  ),
                  const Text(
                    'MCQ Quiz',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    child: const Text('Log In'),
                    onPressed: () {
                      // Implement the login logic here
                      authController.signinwithemail(
                          _emailController.text, _passwordController.text);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    child: const Text('Forgot Password?'),
                    onPressed: () {
                      // Implement the forgot password logic here
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Or Log In With',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // IconButton(
                      //   icon: const Icon(Icons.email),
                      //   onPressed: () {
                      //     // Implement the email login logic here
                      //   },
                      // ),
                      IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () {
                          Get.to(MyPhone());
                          // Implement the phone login logic here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.g_mobiledata_outlined),
                        onPressed: () {
                          authController.googleLogin();
                          // Implement the Google login logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
