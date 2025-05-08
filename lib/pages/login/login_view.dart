import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/common/api/fireAuth.dart';
import 'package:recipe/pages/TabView/home.dart';
import 'package:recipe/pages/forgotPassword/forgotPassword.dart';
import 'package:recipe/pages/register/register_view.dart';
import 'package:recipe/pages/widget/buttonComponent.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool ifShowPassword = true;

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password can\'t be empty';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null; // returns null if the password is valid
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign in',
            style: TextStyle(
              color: Color(0xFF282828),
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width - 64,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFDDDDDD),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/email.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controllerAccount,
                    decoration: const InputDecoration(
                      hintText: "Your Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color(0xFF595959),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width - 64,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFDDDDDD),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/password.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controllerPassword,
                    obscureText: ifShowPassword,
                    decoration: const InputDecoration(
                      hintText: "Your password",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color(0xFF595959),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      ifShowPassword = !ifShowPassword;
                    });
                  },
                  child: Image.asset(
                    "assets/visibility.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: MediaQuery.of(context).size.width - 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(),
                        ),
                        (route) => false);
                  },
                  child: const Text(
                    'Continue As A Guest',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF282828),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ));
                  },
                  child: const Text(
                    'Forgot Password?',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF282828),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          InkWell(
            onTap: () async {
              String? passwordError = validatePassword(controllerPassword.text.trim());
              if (passwordError != null) {
                EasyLoading.showError(passwordError);
                return; // Stop the sign-in process if there's an error
              }
              EasyLoading.show(status: 'loading...');
              try {
                // Attempt to sign in with email and password
                User? user = await FireAuth.signInUsingEmailPassword(
                  email: controllerAccount.text.trim(),
                  password: controllerPassword.text.trim(),
                );
                if (user != null) {
                  // Successfully logged in
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                    (route) => false);
                } else {
                  EasyLoading.showError('Unknown error occurred');
                }
              } catch (e) {
                print('Error: $e');
                if (e is FirebaseAuthException) {
                 print('Firebase Auth Exception Code: ${e.code}');
                 print('Firebase Auth Exception Message: ${e.message}');
                 EasyLoading.showError(e.message ?? 'Failed to sign in with Email & Password');
                 } else {
                  EasyLoading.showError('An unknown error occurred. Please try again.');
                }
                EasyLoading.dismiss();
              } finally {
                EasyLoading.dismiss();
              }
            },
            child: ButtonComponent(
              btnColor: const Color(0xff282828),
              text: "SIGN IN",
              btnWidth: (MediaQuery.of(context).size.width - 64),
              borderRadius: 12,
              textColor: Colors.white,
            ),
          ),
          const SizedBox(height: 36),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const RegisterView(),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 64,
              alignment: Alignment.centerLeft,
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don’t have an account?  ',
                      style: TextStyle(
                        color: Color(0xFF110C26),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Color(0xFFFF5C00),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
