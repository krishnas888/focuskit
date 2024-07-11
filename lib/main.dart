import 'package:flutter/material.dart';
import 'package:focuskit/provider/focuskit_state.dart';
import 'package:provider/provider.dart';
import 'home/focus_kit_home_screen.dart';



void main() {
  runApp(const MyFocusKitApp());
}

class MyFocusKitApp extends StatelessWidget {
  const MyFocusKitApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => FocusKitState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pomodoro Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: focusKitHomeScreen(),
      ),
    );
  }
}






