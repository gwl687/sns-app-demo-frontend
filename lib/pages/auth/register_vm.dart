import 'dart:async';

import 'package:demo10/repository/api.dart';
import 'package:flutter/cupertino.dart';

class RegisterViewModel extends ChangeNotifier {
  Timer? _timer;
  DateTime? _nextSendTime;

  bool get canSendCode {
    if (_nextSendTime == null) return true;
    return DateTime.now().isAfter(_nextSendTime!);
  }

  int get countdown {
    if (_nextSendTime == null) return 0;
    final diff = _nextSendTime!.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  /// 发送验证码
  Future<void> sendCode(String email) async {
    if (!canSendCode) return;

    _nextSendTime = DateTime.now().add(const Duration(seconds: 60));
    notifyListeners();

    await Api.instance.sendVerificationCode(email);

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (canSendCode) {
        timer.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  /// 注册
  Future<bool> register({
    required String email,
    required String code,
    required String password,
  }) async {
    return await Api.instance.register(email, code, password);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
