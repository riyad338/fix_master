import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const DashboardButton(
      {required this.label,
      this.color = Colors.black54,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          label,
          style:
              TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 16.sp),
        ),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
