import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintechquizapp/view/authentication/home/Hompage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  bool isLoggedin = false;
  // List<int> quizScores = [8, 6, 10, 9, 7,1,2,3,4,5,];
  List<int> quizScores = [];
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getUserQuizScores(userId);
    // update();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final Credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(Credential);
  }

  Future<void> getUserQuizScores(String userId) async {
    final collectionRef = FirebaseFirestore.instance.collection('scores');
    final querySnapshot = await collectionRef.get();

    for (final docSnapshot in querySnapshot.docs) {
      final uId = docSnapshot.get('userid');
      final totalScore = docSnapshot.get('totalscore');
      if (userId == uId) {
        if (quizScores.contains(totalScore) == false) {
          quizScores.add(totalScore);
        }
      }

      // print('User ID: $userId, Total Score: $totalScore');
    }
  }

  void listenAuthChanges() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // print('User is currently signed out!');
        // Get.to()
      } else {
        print('User is signed in!');
        isLoggedin = true;
        update();
      }
    });
  }

  Future<void> signinwithemail(String email, String password) async {
    EasyLoading.show(status: 'Loading');
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.to(Homepage(quizScores));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        await createWithEmailPass(email, password);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        EasyLoading.showToast('Wrong password provided for that user.');
      }
    }
    EasyLoading.dismiss();
  }

  // Future

  Future<void> createWithEmailPass(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      EasyLoading.showToast(e.message.toString());
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        EasyLoading.showToast('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        // EasyLoading.showToast('The account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
  }
}
