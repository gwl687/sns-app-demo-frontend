import 'dart:io';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/auth/register_page.dart';
import 'package:demo10/pages/auth/register_vm.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/group_chat_vm.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

final ValueNotifier<int> loginNotifier = ValueNotifier<int>(0);

class LoginInfo {
  String? name;
  String? password;
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginInfo loginInfo = LoginInfo();
  WebSocket? _socket;

  final TextEditingController _passwordController = TextEditingController(
    text: "123456", // 默认密码
  );
  final TextEditingController _usernameController = TextEditingController();

  List<String> _historyAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadHistoryAccounts();
  }

  /// 加载历史账号
  Future<void> _loadHistoryAccounts() async {
    List<String>? list = await SpUtils.getStringList("login_history");
    setState(() {
      _historyAccounts = list ?? [];
    });
  }

  /// 保存账号到历史记录
  Future<void> _saveAccount(String account) async {
    List<String>? list = await SpUtils.getStringList("login_history") ?? [];
    if (!list.contains(account)) {
      list.insert(0, account); // 最新账号放前面
      await SpUtils.saveStringList("login_history", list);
    }
  }

  @override
  void dispose() {
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Loginpage")),
          body: Stack(
            children: [
              AbsorbPointer(
                absorbing: vm.isLoggingIn,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 用户名
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: "username",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          loginInfo.name = value;
                        },
                      ),

                      if (_historyAccounts.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          "history",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: _historyAccounts.length,
                            itemBuilder: (context, index) {
                              final account = _historyAccounts[index];
                              return ListTile(
                                title: Text(account),
                                onTap: () {
                                  _usernameController.text = account;
                                  loginInfo.name = account;
                                },
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      /// 密码
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          loginInfo.password = value;
                        },
                      ),

                      const SizedBox(height: 32),

                      ///登录
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: vm.isLoggingIn
                              ? null
                              : () async {
                                  loginInfo.password = _passwordController.text;
                                  await vm.login(loginInfo);
                                },
                          child: const Text("login"),
                        ),
                      ),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => RegisterPage()),
                            );
                          },
                          child: const Text("register"),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Google 登录
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: vm.isLoggingIn
                              ? null
                              : () async {
                                  await vm.googleLogin();
                                },
                          icon: Image.network(
                            'https://developers.google.com/identity/images/g-logo.png',
                            width: 18,
                            height: 18,
                          ),
                          label: const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFDADCE0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///loading覆盖层
              if (vm.isLoggingIn)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
