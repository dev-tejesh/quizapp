import 'package:fintechquizapp/controller/authcontroller.dart';
import 'package:fintechquizapp/controller/quizcontroller.dart';
import 'package:fintechquizapp/view/authentication/home/quizpage.dart';
import 'package:fintechquizapp/view/authentication/home/sidedrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  final List<int> scores;
  Homepage(this.scores, {Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final authController = Get.put(AuthController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authController.getUserQuizScores(authController.userId.toString());
    setState(() {});
  }

  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
        init: QuizController(),
        builder: (quizController) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quiz Scores'),
            ),
            drawer: sideDrawer(),
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome ${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Your Previous Scores:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  authController.quizScores.isEmpty
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: widget.scores.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[200],
                                ),
                                child: Text(
                                  'Quiz ${index + 1}: ${widget.scores[index]}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      quizController.fetchQuizQuestions();

                      Get.to(() => QuizScreen());
                    },
                    child: const Text('Start New Quiz'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
