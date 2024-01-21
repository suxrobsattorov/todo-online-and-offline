import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/Colors.dart';
import '../constants/images.dart';
import '../provider/auth.dart';
import '../widgets/auth_button.dart';
import 'home.dart';

enum AuthType {
  // ignore: constant_identifier_names
  SIGN_IN,
  // ignore: constant_identifier_names
  SIGN_UP
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthType authType = AuthType.SIGN_IN;
  GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _loading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xatolik'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay!'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _loading = true;
      });
      try {
        if (authType == AuthType.SIGN_IN) {
          await Provider.of<Auth>(context, listen: false).login(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          // ... register user
          await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
          );
        }

         // ignore: use_build_context_synchronously
         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } on HttpException catch (error) {
        var errorMessage = 'Xatolik sodir bo\'ldi.';
        if (error.message.contains('EMAIL_EXISTS')) {
          errorMessage = 'Email band.';
        } else if (error.message.contains('INVALID_EMAIL')) {
          errorMessage = 'To\'g\'ri email kiriting.';
        } else if (error.message.contains('WEAK_PASSWORD')) {
          errorMessage = 'Juda oson parol';
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Bu email bilan foydalanuvchi topilmadi.';
        } else if (error.message.contains('INVALID_PASSWORD')) {
          errorMessage = 'Parol noto\'g\'ri.';
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage =
            'Kechirasiz xatolik sodir bo\'ldi. Qaytadan o\'rinib ko\'ring.';
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22,
            vertical: MediaQuery.of(context).padding.top + 44,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  AppImages.auth,
                  height: 201,
                  width: 201,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Iltimos, email manzil kiriting.';
                    } else if (!email.contains('@')) {
                      return 'Iltimos, to\'g\'ri email kiriting.';
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Iltimos, parolni kiriting.';
                    } else if (password.length < 6) {
                      return 'Parol juda oson.';
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                const SizedBox(height: 10),
                authType == AuthType.SIGN_IN
                    ? Container()
                    : TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Conform Password',
                        ),
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        validator: (confirmedPassword) {
                          if (_passwordController.text != confirmedPassword) {
                            return 'Parollar bir biriga mos kelmadi';
                          }
                          return null;
                        },
                      ),
                const SizedBox(height: 38),
                _loading
                    ? const CircularProgressIndicator()
                    : InkWell(
                        onTap: () {
                          _submit();
                        },
                        child: AuthButton(
                          name: authType == AuthType.SIGN_IN
                              ? 'Kirish'
                              : 'Ro\'yhatdan o\'tish',
                        ),
                      ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () {
                    authType == AuthType.SIGN_IN
                        ? authType = AuthType.SIGN_UP
                        : authType = AuthType.SIGN_IN;
                    setState(() {});
                  },
                  child: Text(
                    authType == AuthType.SIGN_UP
                        ? 'Kirish'
                        : 'Ro\'yhatdan o\'tish',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
