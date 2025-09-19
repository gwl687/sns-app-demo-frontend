import 'package:demo10/pages/auth/login_page.dart';
import 'package:demo10/pages/personal/person_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../route/route_utils.dart';

class PersonalPage extends StatefulWidget {
  @override
  State createState() {
    return _PersonalPage();
  }
}

class _PersonalPage extends State<PersonalPage> {
  PersonViewModel viewModel = PersonViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _header(() {
                if (viewModel.shouldLogin) {
                  RouteUtils.push(context, LoginPage());
                }
              }),
              _settingsItem("我的收藏", () {}),
              _settingsItem("检查更新", () {}),
              _settingsItem("关于我们", () {}),
              Consumer<PersonViewModel>(builder: (context,vm,child){
                if(vm.shouldLogin){
                  return SizedBox();
                }
                return  _settingsItem("退出登录", () {
                  viewModel.logout((value){
                    if(value){
                      RouteUtils.pushAndRemoveUntil(context, LoginPage());
                    }
                  });
                });
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsItem(String? title, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        width: double.infinity,
        height: 45.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5.r),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? "",
              style: TextStyle(color: Colors.black, fontSize: 13.sp),
            ),
            Image.asset(
              "assets/images/img_arrow_right.png",
              width: 20.r,
              height: 20.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(GestureTapCallback? onTap) {
    return Container(
      alignment: Alignment.center,
      color: Colors.teal,
      width: double.infinity,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(35.r)),
              child: Image.asset(
                "assets/images/logo.png",
                width: 70.r,
                height: 70,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Consumer<PersonViewModel>(
            builder: (context, vm, child) {
              return GestureDetector(
                onTap: onTap,
                child: Text(
                  vm.username ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
