import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker/services/auth_repository.dart';
import 'package:exercise_tracker/utils/app_strings.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _auth = AuthRepository();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome(String userName) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(userName: userName),
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }
  
  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final credential = await _auth.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (credential.user != null) {
          _navigateToHome(credential.user!.displayName ?? credential.user!.email ?? 'User');
        }

      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'user-not-found' || e.code == 'invalid-email') {
            _errorMessage = AppStrings.userNotFound;
          } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
            _errorMessage = AppStrings.wrongPassword;
          } else {
            _errorMessage = AppStrings.errorOccurred;
          }
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top + 50),
            
            Center(
              child: Image.asset(
                'assets/images/logo_kilo.png', 
                height: 80,
              ),
            ),
            const SizedBox(height: 30),

            const Center(
              child: Text(
                AppStrings.welcomeMessage,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 16, color: kTextColor.withAlpha(178)),
                  children: <TextSpan>[
                    TextSpan(
                      text: AppStrings.logIn,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal, 
                        decoration: TextDecoration.underline,
                        color: kTextColor, 
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' ${AppStrings.or} '),
                    TextSpan(
                      text: AppStrings.signUp,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color: kTextColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _navigateToSignUp,
                    ),
                    const TextSpan(text: AppStrings.logInToStart),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.email,
                    style: TextStyle(
                      color: kTextColor.withAlpha(178),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppStrings.emailHint, // AppStrings
                      hintStyle: TextStyle(color: kTextColor.withAlpha(100)),
                      filled: true,
                      fillColor: kInputFillColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return AppStrings.emailInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(
                    AppStrings.password,
                    style: TextStyle(
                      color: kTextColor.withAlpha(178),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppStrings.passwordHint,
                      hintStyle: TextStyle(color: kTextColor.withAlpha(100)),
                      filled: true,
                      fillColor: kInputFillColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                          color: kTextColor.withAlpha(178)
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                    ),
                    obscureText: _isPasswordObscured,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      if (value.length < 6) {
                        return AppStrings.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _navigateToForgotPassword,
                child: const Text(
                  AppStrings.forgotPassword,
                  style: TextStyle(
                    color: kSecondaryColor,
                    decoration: TextDecoration.underline,
                    fontSize: 16
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin, 
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: kTextColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: kTextColor)
                : const Text(
                    AppStrings.logIn,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            ),
            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: _navigateToSignUp,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: const BorderSide(color: kSecondaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                AppStrings.signUp,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kSecondaryColor),
              ),
            ),
            const SizedBox(height: 40),

            TextButton(
              child: const Text(
                "Згенерувати тестовий краш",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                FirebaseCrashlytics.instance.crash();
              },
            ),
          ],
        ),
      ),
    );
  }
}