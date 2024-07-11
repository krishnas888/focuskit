import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utility/colors_code.dart';

class TimerTextWidget extends StatelessWidget {
  final Duration currentTime;

  TimerTextWidget(this.currentTime);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Text(
      '${currentTime.inMinutes}:${(currentTime.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(fontSize: 32.sp,letterSpacing: 3,color: MyColors.appDarkBlue),
    );
  }
}