import 'package:cupu/handlers/auth_handler.dart';
import 'package:cupu/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/ti_component.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  
  String email = '';
  String password = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Email tidak terdaftar';
        case 'wrong-password':
          return 'Password salah';
        case 'invalid-email':
          return 'Format email tidak valid';
        case 'user-disabled':
          return 'Akun telah dinonaktifkan';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Silakan coba lagi nanti';
        default:
          return 'Error: ${error.message}';
      }
    }
    return 'Terjadi kesalahan. Silakan coba lagi';
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get UserStore instance outside of async operation
        final userStore = RM.get<UserStore>();
        
        final auth = AuthHandler(
          email: email.trim(),
          password: password,
        );

        final status = await auth.signIn(email.trim(), password);

        if (mounted) {
          if (status["isvalid"]) {
            // Update state using proper error handling
            try {
              userStore.setState((state) => state.setLogStatus(true));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login berhasil!"),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              print("Error updating state: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login berhasil tapi terjadi error. Silakan coba lagi."),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getFirebaseErrorMessage(status["error"])),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getFirebaseErrorMessage(e)),
              backgroundColor: Colors.red,
            ),
          );
        }
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Login Cupu App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            TiComponent(
              label: "Email",
              hint: "user@contoh.com",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "Email diperlukan";
                }
                if (!EmailValidator.validate(value.trim())) {
                  return "Email tidak valid";
                }
                return null;
              },
              change: (value) {
                setState(() {
                  email = value.trim();
                });
              },
            ),
            const SizedBox(height: 20.0),
            TiComponent(
              label: "Password",
              hint: "Masukkan password",
              controller: _passwordController,
              isPassword: true,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "Password diperlukan";
                }
                if (value.length < 6) {
                  return "Password minimal 6 karakter";
                }
                return null;
              },
              change: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "MASUK",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          final userStore = RM.get<UserStore>();
                          userStore.setState((state) => state.setRegisterStatus(true));
                        },
                  child: const Text(
                    "Pengguna Baru?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}