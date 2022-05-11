import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_chat/widget/user_image_picker.dart';

const invalidEmailAddress = 'Please enter a valid email address.';
const invalidUsername = 'Please enter at least 4 characters';
const invalidPassword = 'Password must be at least 7 characters long.';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    File? image,
    BuildContext context,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = true;
  File? _image;

  void pickImage(File pickedImage) {
    _image = pickedImage;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();

    if (_image == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    widget.submitFn(
        _userEmail, _userName, _userPassword, _isLogin, _image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(pickImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value == null) {
                        return invalidEmailAddress;
                      }

                      if (value.isEmpty || !value.contains('@')) {
                        return invalidEmailAddress;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      if (value == null) {
                        return;
                      }
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value == null) {
                          return invalidUsername;
                        }

                        if (value.isEmpty || value.length < 4) {
                          return invalidUsername;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        if (value == null) {
                          return;
                        }
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value == null) {
                        return invalidPassword;
                      }
                      if (value.isEmpty || value.length < 7) {
                        return invalidPassword;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      if (value == null) {
                        return;
                      }
                      _userPassword = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
