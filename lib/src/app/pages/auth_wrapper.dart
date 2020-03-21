import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:train_beers/src/app/pages/login/login_view.dart';
import 'home/home_view.dart';

/// This class is responsible for directing the user to the appropriate widget 
/// branch based on their authentication status.
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen for changes to the user identifier stream from the provider.
    String userIdentifier = Provider.of<String>(context);
    // Take the user to the login page if no user identifier exists.
    if (userIdentifier == null || userIdentifier == "") {
      return LoginPage(title: "Sign In");
    }
    
    return HomePage(title: "Home");
  }
}