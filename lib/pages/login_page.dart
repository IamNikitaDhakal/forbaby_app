// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../style/app_colors.dart';
import '../validation/loginvalidation.dart';
import 'authentication_page.dart'; // Import the authentication page
import 'forgetpage.dart';
import 'homepage.dart'; // Import your home page widget
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

// Made the state class public
class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final Logger _logger = Logger('LoginPage');
  final AuthenticationPage _auth = AuthenticationPage();

  @override
  Widget build(BuildContext context) {
    _setupLogging();

    return Center(
      child: Scaffold(
        appBar: AppBar(
          leading: _buildBackButton(context),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Adjust border radius as needed
                    child: Container(
                      color: Colors.white, // Add a background color if needed
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildTextInput(),
              _buildPasswordInput(),
              _buildLoginButton(context), // Pass context to the button method
              _buildForgotPasswordLink(context),
              _buildSignUpLink(context),
            ],
          ),
        ),
      ),
    );
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  CupertinoButton _buildBackButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: boderColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 194, 227, 252),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          labelText: 'Username',
          hintText: 'Enter your name',
          prefixIcon: const Icon(Icons.person),
        ),
        validator: LoginValidation.validateUsername,
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 194, 227, 252),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: const Icon(Icons.key),
        ),
        validator: LoginValidation.validatePassword,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            // Log the username and password
            _logger.info('Username: ${_usernameController.text}');
            _logger.info('Password: ${_passwordController.text}');

            // Call authentication method
            try {
              final user = await _auth.loginUserWithEmailAndPassword(
                _usernameController.text,
                _passwordController.text,
              );
              if (user != null) {
                // Navigate to the home page
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } else {
                // Handle authentication failure
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to log in')),
                );
              }
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An error occurred: $e')),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 26.0),
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: const Color.fromARGB(255, 226, 110, 229), // Add color here
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white, // Set the text color here
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Color.fromARGB(255, 226, 110, 229), // Set the text color here
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account? "),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Color.fromARGB(255, 226, 110, 229), // Set the text color here
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
