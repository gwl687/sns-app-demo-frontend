import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//通用的输入框
Widget commonInput({
  String? labelText,
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
  bool? obscureText
}) {
  return TextField(
    obscureText: obscureText??false,
    controller: controller,
    onChanged: onChanged,
    style: TextStyle(color: Colors.white, fontSize: 14.sp),
    cursorColor: Colors.white,
    decoration: InputDecoration(
      //未获取焦点前边框样式
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.5.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.r),
      ),
      labelText: labelText ?? "请输入",
      labelStyle: const TextStyle(color: Colors.white),
    ),
  );
}

//白色边框按钮
Widget whiteBorderButton({required String title, GestureTapCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.only(left: 40.w, right: 40.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(22.5.r)),
        border: Border.all(color: Colors.white, width: 1.r),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
      ),
    ),
  );
}
