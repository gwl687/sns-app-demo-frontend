import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/route/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../common_ui/common_style.dart';

class RegisterPage extends StatefulWidget {
  @override
  State createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  AuthViewModel viewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          alignment: Alignment.center,
          child: Consumer<AuthViewModel>(
            builder: (context, vm, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonInput(
                    labelText: "输入账号",
                    onChanged: (value) {
                      vm.registerInfo.name = value;
                    },

                  ),
                  SizedBox(height: 20.h),
                  commonInput(
                    labelText: "输入密码",
                    onChanged: (value) {
                      vm.registerInfo.password = value;
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 50.h),
                  commonInput(
                    labelText: "再次输入密码",
                    onChanged: (value) {
                      vm.registerInfo.rePassword = value;
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 50.h),
                  whiteBorderButton(
                    title: "点我注册",
                    onTap: () {
                      viewModel.register().then((value) {
                        if (value == true) {
                          showToast("注册成功");
                          RouteUtils.pop(context);
                        }
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
