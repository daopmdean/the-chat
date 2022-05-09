import 'package:flutter/material.dart';
import 'package:the_chat/widget/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _submitForm(
    String email,
    String username,
    String password,
    bool isLogin,
  ) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm),
    );
  }
}
