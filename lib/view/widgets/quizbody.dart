import 'package:fintechquizapp/view/authentication/home/quizpage.dart';
import 'package:flutter/material.dart';

class QuizBody extends StatelessWidget {
  final QuizQuestion currentQuestion;
  final int? selectedAnswerIndex;
  final int remainingTime;
  final Function(int) onAnswerSelected;
  final VoidCallback onNextPressed;

  QuizBody({
    required this.currentQuestion,
    required this.selectedAnswerIndex,
    required this.remainingTime,
    required this.onAnswerSelected,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            currentQuestion.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Time Remaining: ${remainingTime}s',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.answers.length,
              itemBuilder: (BuildContext context, int index) {
                Color answerColor = Colors.transparent;
                if (selectedAnswerIndex != null) {
                  if (selectedAnswerIndex == index) {
                    answerColor = currentQuestion.correctAnswerIndex == index
                        ? Colors.green
                        : Colors.red;
                  } else if (currentQuestion.correctAnswerIndex == index) {
                    answerColor = Colors.green;
                  }
                }

                return GestureDetector(
                  onTap: () {
                    if (selectedAnswerIndex == null) {
                      onAnswerSelected(index);
                      // Future.delayed(const Duration(seconds: 1), () {
                      //   onNextPressed();
                      // });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: answerColor,
                    ),
                    child: Text(
                      currentQuestion.answers[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: (() {
                onNextPressed();
              }),
              child: const Text('Next Question'))
        ],
      ),
    );
  }
}
