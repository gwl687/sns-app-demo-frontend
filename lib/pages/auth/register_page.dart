import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/register_vm.dart';
import 'package:demo10/route/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Register")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// 邮箱
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                /// 验证码
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: "Verification Code",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: vm.canSendCode
                            ? () async {
                                final email = _emailController.text.trim();

                                if (email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Email is required"),
                                    ),
                                  );
                                  return;
                                }

                                if (!_isValidEmail(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Invalid email format"),
                                    ),
                                  );
                                  return;
                                }

                                await vm.sendCode(email);
                              }
                            : null,
                        child: Text(
                          vm.canSendCode ? "Send" : "${vm.countdown}s",
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 密码
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                /// 确认密码
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                /// 注册按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final code = _codeController.text.trim();
                      final password = _passwordController.text;
                      final confirm = _confirmController.text;

                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email is required")),
                        );
                        return;
                      }

                      if (!_isValidEmail(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid email format")),
                        );
                        return;
                      }

                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Verification code is required"),
                          ),
                        );
                        return;
                      }

                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password must be at least 6 characters",
                            ),
                          ),
                        );
                        return;
                      }

                      if (password != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                          ),
                        );
                        return;
                      }

                      bool result = await vm.register(
                        email: email,
                        code: code,
                        password: password,
                      );
                      if (!result) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Register success",
                            style: TextStyle(fontSize: 13),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      await Future.delayed(const Duration(milliseconds: 800));

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);
  }
}
