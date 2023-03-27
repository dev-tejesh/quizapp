import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintechquizapp/controller/quizcontroller.dart';
import 'package:fintechquizapp/view/authentication/home/scorescreen.dart';
import 'package:fintechquizapp/view/widgets/quizbody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  Timer? quizTimer;
  int toppers = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // fetchQuizQuestions();

    startTimer();
  }

  @override
  void dispose() {
    quizTimer?.cancel();
    super.dispose();
    selectedAnswerIndex = -1; // s
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    quizTimer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (timer.tick >= 15) {
          selectedAnswerIndex = -1;
          timer.cancel();
          Future.delayed(const Duration(seconds: 1), () {
            nextQuestion();
          });
        }
      });
    });
  }

  final quizController = Get.put(QuizController());

  void selectAnswer(int index) {
    bool isCorrect = index ==
        quizController.quizQuestions[currentQuestionIndex].correctAnswerIndex;
    setState(() {
      selectedAnswerIndex = index;
      // quizController.userAnswers[currentQuestionIndex] = selectedAnswerIndex;
      quizTimer?.cancel();
      if (isCorrect) {
        // advancedPlayer = await AudioCache().load("music/song3.mp3");
        // audioCache.
        final player = AudioPlayer();
        player.setSource(AssetSource('correct.mp3'));
        player.play(AssetSource('correct.mp3'));
        toppers = toppers + 1;
        // Correct answer feedback
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Correct!'),
            content: const Text('Congratulations, your answer is correct!'),
            actions: [
              TextButton(
                child: const Text('Next'),
                onPressed: () {
                  Navigator.pop(context);
                  if (index < quizController.quizQuestions.length) {
                    nextQuestion();
                  } else {
                    Get.to(ScoreScreen(score: 10));
                  }
                },
              ),
            ],
          ),
        );
      } else {
        // Incorrect answer feedback
        final player = AudioPlayer();
        player.setSource(AssetSource('wrong.mp3'));
        player.play(AssetSource('wrong.mp3'));
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Incorrect'),
            content: Text(
                'Sorry, your answer is incorrect. The correct answer is: '
                '${quizController.quizQuestions[currentQuestionIndex].answers[quizController.quizQuestions[currentQuestionIndex].correctAnswerIndex]}.'),
            actions: [
              TextButton(
                child: const Text('Next'),
                onPressed: () {
                  Navigator.pop(context);
                  // nextQuestion();
                  if (index < quizController.quizQuestions.length) {
                    nextQuestion();
                  } else {
                    Get.to(ScoreScreen(score: 10));
                  }
                },
              ),
            ],
          ),
        );
      }
    });
  }

  // int calculateScore(List<QuizQuestion> quizQuestions, List<int?> userAnswers) {
  //   int correctAnswers = 0;
  //   for (int i = 0; i < quizQuestions.length; i++) {
  //     if (userAnswers[i] != null &&
  //         userAnswers[i] == quizQuestions[i].correctAnswerIndex) {
  //       correctAnswers++;
  //     }
  //   }
  //   return correctAnswers;
  // }

  void nextQuestion() {
    setState(() {
      selectedAnswerIndex = null;
      if (currentQuestionIndex < quizController.quizQuestions.length - 1) {
        currentQuestionIndex++;
        startTimer();
      } else {
        // Quiz is finished
        currentQuestionIndex = 0;
        print('quiz is finished');

        FirebaseFirestore.instance.collection('scores').add({
          'userid': uid,
          'totalscore': toppers,
        });
        Get.to(ScoreScreen(score: toppers),
            arguments: quizController.quizQuestions.length);
        quizController.quizQuestions = [];
        int correctAnswers = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: quizController.quizQuestions.length > 0
            ? Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) /
                        quizController.quizQuestions.length,
                    semanticsLabel:
                        "Question ${currentQuestionIndex + 1} out of ${quizController.quizQuestions.length}",
                  ),
                  Text(
                      "Question ${currentQuestionIndex + 1} out of ${quizController.quizQuestions.length}"),
                  const SizedBox(height: 16),
                  Expanded(
                    child: QuizBody(
                      currentQuestion:
                          quizController.quizQuestions[currentQuestionIndex],
                      selectedAnswerIndex: selectedAnswerIndex,
                      // remainingTime: 15 - quizTimer?.tick ?? 0,
                      remainingTime: 15 - (quizTimer?.tick ?? 0),
                      onAnswerSelected: selectAnswer,
                      onNextPressed: nextQuestion,
                    ),
                  ),
                ],
              )
            : Container());
  }
}
