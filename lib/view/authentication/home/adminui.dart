import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answer1 = TextEditingController();
  final TextEditingController _answer2 = TextEditingController();
  final TextEditingController _answer3 = TextEditingController();
  final TextEditingController _answer4 = TextEditingController();
  final List _answerControllers = [];
  // List.generate(4, (_) => TextEditingController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _questionController.dispose();
    _answer1.dispose();
    _answer2.dispose();
    _answer3.dispose();
    _answer4.dispose();

    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final question = _questionController.text;
    // final answers =
    //     _answerControllers.map((controller) => controller.text).toList();
    _answerControllers.add(_answer1.text.toString());
    _answerControllers.add(_answer2.text.toString());
    _answerControllers.add(_answer3.text.toString());
    _answerControllers.add(_answer4.text.toString());
    final correctAnswerIndex = _answerControllers.indexOf(
        _answerControllers.firstWhere((answer) => answer.startsWith('*')));
    // int correctAnswerIndex = 0;

    await _firestore.collection('quizQuestions').add({
      'question': question,
      'answers': _answerControllers,
      'correctAnswerIndex': correctAnswerIndex,
    });

    _questionController.clear();
    // _answerControllers.forEach((controller) => controller.clear());
    _answerControllers.clear();
    _answer1.clear();
    _answer2.clear();
    _answer3.clear();
    _answer4.clear();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a new question',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // _buildAnswerTextField(0),
                TextFormField(
                  controller: _answer1,
                  decoration: const InputDecoration(
                    labelText: 'answer1',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter answer1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer2,
                  decoration: const InputDecoration(
                    labelText: 'answer2',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter answer2';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer3,
                  decoration: const InputDecoration(
                    labelText: 'answer3',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer4,
                  decoration: const InputDecoration(
                    labelText: 'answer4',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Question'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerTextField(int index) {
    return TextFormField(
      controller: _answerControllers[index],
      decoration: InputDecoration(
        labelText: 'Answer ${index + 1}',
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an answer';
        }
        if (value.startsWith('*') && index != 0) {
          return 'Correct answer should be the first answer';
        }
        return null;
      },
    );
  }
}
