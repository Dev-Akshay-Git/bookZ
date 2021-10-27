import 'dart:async';

import 'package:bookz/Screens/home_page.dart';
import 'package:bookz/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginBloc {
  final _email = BehaviorSubject<String>();
  final _pwd = BehaviorSubject<String>();
  final Authenticate _auth = Authenticate();
  final bool validPwdandEmail = true;

  //Getter
  Stream<String> get userEmail => _email.stream.transform(validateUserName);
  Stream<String> get password => _pwd.stream.transform(validatePassword);
  Stream<bool> get fieldsValid =>
      Rx.combineLatest([userEmail, password], (values) {
        return true;
      });
  //Setter
  Function(String) get changeUserName => _email.sink.add;
  Function(String) get changePassword => _pwd.sink.add;

  //transformers
  final validateUserName = StreamTransformer<String, String>.fromHandlers(
      handleData: (userEmail, sink) async {
    if (userEmail.length < 3) {
      sink.addError('User Name must be atleast 3 characters');
    } else if (userEmail.contains('-') ||
        userEmail.contains('*') ||
        userEmail.contains(' ') ||
        userEmail.contains(',') ||
        !userEmail.contains('@') ||
        !userEmail.contains('.com')) {
      sink.addError('Enter a valid email');
    } else {
      sink.add(userEmail);
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (pwd, sink) async {
    if (pwd.length < 3) {
      sink.addError('Passwords must be atleast 3 characters');
    } else if (pwd.contains(' ')) {
      sink.addError('Passwords must not contain ant white space');
    } else {
      sink.add(pwd);
    }
  });

  Future<void> SubmitButton(BuildContext context) async {
    print("this is sumbit");
    User? result;
    try {
      result = await _auth.signInEmailAndPassword(_email.value, _pwd.value);
    } catch (e) {
      _pwd.sink.addError(e);
      _email.sink.addError(e);
    }
    if (result == null) {
      _pwd.sink.addError("invalid password");
      _email.sink.addError("invalid user");
    } else {
      SharedPreferences userID = await SharedPreferences.getInstance();
      await userID.setString("UserID", result.uid);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  dispose() {
    _email.close();
    _pwd.close();
  }
}
