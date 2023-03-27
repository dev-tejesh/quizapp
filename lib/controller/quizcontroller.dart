import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintechquizapp/view/authentication/home/quizpage.dart';
import 'package:get/state_manager.dart';

class QuizController extends GetxController {
  List<QuizQuestion> quizQuestions = [];
  List<int?> userAnswers = [];
  void initState() {
    fetchQuizQuestions();
    userAnswers = List.filled(quizQuestions.length, null);
  }

  Future<List<QuizQuestion>> fetchQuizQuestions() async {
    final quizQuestionsRef =
        FirebaseFirestore.instance.collection('quizQuestions');
    final querySnapshot = await quizQuestionsRef.get();

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final question = data['question'];
      final answers = List<String>.from(data['answers']);
      final correctAnswerIndex = data['correctAnswerIndex'];

      final quizQuestion = QuizQuestion(
        question: question,
        answers: answers,
        correctAnswerIndex: correctAnswerIndex,
      );
      quizQuestions.add(quizQuestion);
    }
    update();
    return quizQuestions;
  }
}

// Call this function to retrieve the quiz questions
// fetchQuizQuestions();

