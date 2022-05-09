import 'package:flutter/material.dart';

const invalidEmailAddress = 'Please enter a valid email address.';
const invalidUsername = 'Please enter at least 4 characters';
const invalidPassword = 'Password must be at least 7 characters long.';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn);

  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
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

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    widget.submitFn(_userEmail, _userName, _userPassword, _isLogin, context);
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
                  TextFormField(
                    key: const ValueKey('email'),
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
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
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
