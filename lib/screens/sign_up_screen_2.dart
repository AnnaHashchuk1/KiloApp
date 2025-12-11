import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exercise_tracker/utils/app_strings.dart';
import 'package:exercise_tracker/services/auth_repository.dart'; 
import '../utils/constants.dart';
import 'home_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SignUpScreen2 extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  SignUpScreen2({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedGender;

  final AuthRepository _auth = AuthRepository();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _birthDateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _navigateToHome(String userName) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(userName: userName),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _performSignUp({required String registrationMethod}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Прибираємо 'Shos'
    });

    try {
      final credential = await _auth.signUp(
        email: widget.email,
        password: widget.password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(widget.name);
      }

      // Це твій "справжній" logEvent для реєстрації
      widget.analytics.logEvent(
        name: 'sign_up',
        parameters: {
          'registration_method': registrationMethod, 
        },
      );
  
      if (mounted) {
        _navigateToHome(widget.name);
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMessage = AppStrings.emailAlreadyInUse;
        } else {
          _errorMessage = AppStrings.errorOccurred;
        }
      });
    } catch (e) {
      // Універсальний 'catch'
      setState(() {
        _errorMessage = 'Неочікувана помилка: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleCompleteSignUp() {
    if (_formKey.currentState!.validate()) {
      _performSignUp(registrationMethod: 'full_form');
    }
  }

  void _handleSkip() {
    _performSignUp(registrationMethod: 'skip');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: kSecondaryColor, onPrimary: kTextColor, surface: kPrimaryColor, onSurface: kTextColor), 
            dialogTheme: DialogThemeData(backgroundColor: kInputFillColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked));
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
            // ... (увесь твій код Form, TextFormFields і т.д. ... )
            Center(child: Image.asset('assets/images/logo_kilo.png', height: 80)),
            const SizedBox(height: 30),
            const Text(AppStrings.welcomeMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 5),
            Text(AppStrings.trackingJourneyMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: kTextColor.withAlpha(178))),
            const SizedBox(height: 50),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.gender, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true, fillColor: kInputFillColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                    ),
                    isExpanded: true,
                    hint: Text(AppStrings.genderHint, style: TextStyle(color: kTextColor.withAlpha(100))),
                    icon: const Icon(Icons.keyboard_arrow_down, color: kTextColor),
                    dropdownColor: kInputFillColor,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    items: <String>['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                    onChanged: (String? newValue) => setState(() => _selectedGender = newValue),
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(AppStrings.birthDate, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _birthDateController,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppStrings.birthDateHint,
                      hintStyle: TextStyle(color: kTextColor.withAlpha(100)),
                      filled: true, fillColor: kInputFillColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      suffixIcon: Icon(Icons.calendar_today, color: kTextColor.withAlpha(178)),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(AppStrings.phoneNumber, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(color: kTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppStrings.phoneNumberHint,
                      hintStyle: TextStyle(color: kTextColor.withAlpha(100)),
                      filled: true, fillColor: kInputFillColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      suffixIcon: Icon(Icons.phone, color: kTextColor.withAlpha(178)),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                      return null;
                    },
                  ),
                ],
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
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleCompleteSignUp,
              style: ElevatedButton.styleFrom(backgroundColor: kSecondaryColor, foregroundColor: kTextColor, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: _isLoading
                  ? const CircularProgressIndicator(color: kTextColor)
                  : const Text(AppStrings.signUp, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),

            OutlinedButton(
              onPressed: _isLoading ? null : _handleSkip,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), side: const BorderSide(color: kSecondaryColor, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text(AppStrings.skipAndSignUp, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kSecondaryColor)),
            ),

            TextButton(
              child: const Text(
                "Згенерувати non-fatal помилку та LogEvent",
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
              onPressed: () {
                try {
                  throw Exception("ПОМРИ ПОМРИ ПОМРИ ПОМРИ");

                } catch (e, s) {                  
                  FirebaseCrashlytics.instance.recordError(
                    e,
                    s,
                    reason: 'Тестування non-fatal та logEvent',
                    fatal: false
                  );

                  widget.analytics.logEvent(
                    name: 'test_event_from_button_click',
                    parameters: {
                      'error_message': e.toString(),
                    }
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("живи живи живи живи"),
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}