import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/firebase_authentication_repository.dart';
import './login_controller.dart';

class LoginPage extends View {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  // inject dependencies inwards
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ViewState<LoginPage, LoginController> {
  _LoginPageState() : 
    super(LoginController(FirebaseAuthenticationRepository()));

  @override
  Widget buildPage() {  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scaffold(
        key: globalKey,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: controller.emailTextController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.passwordTextController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: controller.login,
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
