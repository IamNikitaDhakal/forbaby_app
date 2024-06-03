// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forbaby_app/pages/login_page.dart';

import '../validation/signuppagevalidation.dart';

class SignUpPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(context),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Sign Up Page",
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Create your account",
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildUsernameInput(),
                _buildEmailInput(),
                _buildPasswordInput(),
                _buildConfirmPasswordInput(),
                _buildSubmitButton(context),
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
        validator: SignUpValidation.validateUsername,
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 194, 227, 252),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          labelText: 'Email',
          hintText: 'Enter your email',
          prefixIcon: const Icon(Icons.mail),
        ),
        validator: SignUpValidation.validateEmail,
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
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          labelText: 'Password',
          hintText: 'Enter your Password',
          prefixIcon: const Icon(Icons.key),
        ),
        validator: SignUpValidation.validatePassword,
      ),
    );
  }

  Widget _buildConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 194, 227, 252),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          labelText: 'Confirm Password',
          hintText: 'Confirm your Password',
          prefixIcon: const Icon(Icons.key),
        ),
        validator: (value) {
          return SignUpValidation.validateConfirmPassword(
              value, _passwordController.text);
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              );
              if (userCredential.user != null) {
                // Log user created successfully
                // Navigate to the home page
                Navigator.pushReplacementNamed(context, '/home');
              }
            } catch (e) {
              // Handle error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign up: $e')),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: const Color.fromARGB(255, 226, 110, 229),
        ),
        child: const Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account? "),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Log In',
              style: TextStyle(
                color: Color.fromARGB(255, 226, 110, 229),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
