import 'package:flutter/material.dart';
import 'package:exercise_tracker/utils/app_strings.dart';
import '../utils/constants.dart';
import 'sign_up_screen_2.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToNextStep() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignUpScreen2(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextColor),
          onPressed: () => Navigator.pop(context), 
        ),
        title: null, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/logo_kilo.png', 
                height: 80,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              AppStrings.welcomeMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              AppStrings.trackingJourneyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: kTextColor.withAlpha(178),
              ),
            ),
            const SizedBox(height: 50),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.name, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8), 
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppStrings.nameHint,
                      hintStyle: TextStyle(color: kTextColor.withAlpha(100)),
                      filled: true,
                      fillColor: kInputFillColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(AppStrings.email, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8), 
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppStrings.emailHint,
                      hintStyle: TextStyle(color: kTextColor.withAlpha(100)),
                      filled: true,
                      fillColor: kInputFillColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return AppStrings.emailInvalid;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(AppStrings.password, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.w600)),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility, color: kTextColor.withAlpha(178)),
                        onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                      ),
                    ),
                    obscureText: _isPasswordObscured,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                      if (value.length < 6) return AppStrings.passwordTooShort;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _navigateToNextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: kTextColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.next,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}