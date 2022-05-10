import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:the_chat/widget/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitForm(
    String email,
    String username,
    String password,
    bool isLogin,
    File? image,
    BuildContext context,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        final creds = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final creds = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(creds.user!.uid + '.jpg');
        await ref.putFile(image!).whenComplete(() => {});
        final userImageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(creds.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': userImageUrl,
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'Error occurred!';
      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print('in general catch ------');
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, _isLoading),
    );
  }
}
