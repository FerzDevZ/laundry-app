import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isLoading = false;
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoAnimation = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut);
    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    EasyLoading.show(status: 'Logging in...');
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      EasyLoading.dismiss();
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Login gagal';
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Login Gagal',
          desc: errorMsg,
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      EasyLoading.dismiss();
      setState(() => isLoading = false);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'Gagal menghubungi server.\n$e',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = Theme.of(context).platform == TargetPlatform.fuchsia; // hack for hover effect on web
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.18),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _logoAnimation,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                        margin: const EdgeInsets.only(bottom: 18),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF4e54c8),
                          child: const Icon(Icons.local_laundry_service, size: 56, color: Colors.white),
                        ),
                      ),
                    ),
                    const Text(
                      "Esemka Laundry",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4e54c8),
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Color(0x338f94fb),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Focus(
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF4e54c8), width: 2),
                              ),
                              fillColor: hasFocus ? const Color(0x118f94fb) : Colors.transparent,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Email wajib diisi';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Format email tidak valid';
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Focus(
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return TextFormField(
                            controller: passwordController,
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF4e54c8), width: 2),
                              ),
                              fillColor: hasFocus ? const Color(0x118f94fb) : Colors.transparent,
                              filled: true,
                              suffixIcon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                child: IconButton(
                                  key: ValueKey(isObscure),
                                  icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4e54c8)),
                                  onPressed: () => setState(() => isObscure = !isObscure),
                                  tooltip: isObscure ? "Lihat Password" : "Sembunyikan Password",
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Password wajib diisi';
                              if (value.length < 4) return 'Password minimal 4 karakter';
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    MouseRegion(
                      cursor: isWeb ? SystemMouseCursors.click : MouseCursor.defer,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: isLoading
                              ? null
                              : const LinearGradient(
                                  colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text("Login"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
