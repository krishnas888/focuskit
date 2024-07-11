import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../provider/focuskit_state.dart';
import '../utility/colors_code.dart';
import '../widget/timer_text_widget.dart';

class focusKitHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Focus Timer')),
        backgroundColor: MyColors.appGreen,
      ),

      body: Padding(
        padding: EdgeInsets.all(2.spMin),
        child: Center(
          child: Consumer<FocusKitState>(
            builder: (context, pomodoroState, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>  const LinearGradient(
                          colors: [
                            MyColors.appYellow,
                            MyColors.appGreen,
                          ],
                          stops: [
                            0.0,
                            1.0,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: CircularPercentIndicator(
                          radius: 165.sp,
                          lineWidth: 0.04.sw,
                          animation: false,
                          animationDuration: 1000,
                          percent: pomodoroState.calculateProgress(),
                            circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.blue.withOpacity(0.5),
                          //backgroundColor: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 50.h,
                            width: 150.w,
                            child: TextButton(
                              onPressed: () {
                                _showTimeSelectionDialog(context);
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(color: MyColors.appDarkBlue)),
                              ),
                              child: TimerTextWidget(pomodoroState.currentTime)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Container(
                    width: 0.55.sw,
                    color: MyColors.appYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            pomodoroState.startTimer();
                          },
                        ),
                        12.horizontalSpace,
                        IconButton(
                          icon: const Icon(Icons.pause),
                          onPressed: () {
                            pomodoroState.pauseTimer();
                          },
                        ),
                        12.horizontalSpace,
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: () {
                            pomodoroState.resetTimer();
                          },
                        ),
                      ],
                    ),
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

void _showTimeSelectionDialog(BuildContext context) {
  var pomodoroState = Provider.of<FocusKitState>(context, listen: false);
  int selectedMinutes = pomodoroState.currentTime.inMinutes;
  int selectedSeconds = pomodoroState.currentTime.inSeconds % 60;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Adjust the border radius as needed
        ),

        contentPadding: EdgeInsets.fromLTRB(0.034.sw, 0.012.sh, 0.034.sw, 0.012.sh),
        actionsPadding: EdgeInsets.fromLTRB(0, 0, 0,0.024.sh),
        title: Text('Select Time',style: TextStyle(fontSize: 24,fontWeight:FontWeight.w500,color: MyColors.appDarkBlue),),
        content: Container(
          height: 150.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeSelector('Min', [1,5,10,20,25,30,35,40,45,50,55,60], selectedMinutes, (value) {
                selectedMinutes = value;
              }),
              const Text(
                ':',
                style: TextStyle(fontSize: 34.0),
              ),
              _buildTimeSelector('Sec', [0], selectedSeconds, (value) {
                selectedSeconds = value;
              }),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  int totalSeconds = selectedMinutes * 60 + selectedSeconds;
                  pomodoroState.setTime(Duration(seconds: totalSeconds));
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[300]), // Change button color
                ),
                child: const Text('OK',style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600,color: MyColors.appDarkBlue),),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildTimeSelector(String label, List<int> values, int selectedValue, Function(int) onChanged) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyColors.appGreen, MyColors.appYellow], // Define your gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10), // Optional: Add border radius
        border: Border.all(
            color: Colors.transparent, // Border color
            width: 2
        ),
      ),
      height: 110.0,
      child: ListWheelScrollView(
        itemExtent: 50.0,
        diameterRatio: 2.0,
        physics: FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: values.indexOf(selectedValue)),
        onSelectedItemChanged: (index) {
          onChanged(values[index]);
        },
        children: values.map((value) {
          return Center(
            child: GestureDetector(
              onTap: () {
                onChanged(value);
              },
              child: Text(
                value.toString().padLeft(2, '0'),
                style: TextStyle(fontSize: 24.0.sp,fontWeight: FontWeight.w500,color: MyColors.appDarkBlue),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}



