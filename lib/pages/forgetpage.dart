import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
   ForgotPasswordPage({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Forgot your password?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Enter your email address to reset your password.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _buildEmailInput(),
            const SizedBox(height: 20),
            _buildResetButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor:const Color.fromARGB(255, 194, 227, 252),
          labelText: 'Email',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

   Widget _buildResetButton(BuildContext context) {
     return ElevatedButton(
       onPressed: () {
         _resetPassword(context);
       },
       style: ElevatedButton.styleFrom(
         backgroundColor: const Color.fromARGB (255, 226, 110, 229),
       ),
       child: const Text(
         'Reset Password',
         style: TextStyle(
           color: Colors.white,
           fontSize: 20,
           fontWeight: FontWeight.bold,
         ),
       ),
     );
   }


   Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent successfully.'),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email: $e'),
        ),
      );
    }
  }
}
