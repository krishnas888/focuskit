import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
class FocusKitState extends ChangeNotifier {
  bool isRunning = false;
  Timer? _timer;
  Duration _currentTime = Duration(minutes: 1); // Default Pomodoro duration
  Duration _initialTime = Duration(minutes: 1); // Initial Pomodoro duration
  Duration _tickDuration = Duration(seconds: 1);
  late AudioPlayer audioPlayer; // Declare an AudioPlayer object


  Duration get currentTime => _currentTime;
  FocusKitState() {
    audioPlayer = AudioPlayer(); // Initialize the AudioPlayer object
  }
  void startTimer() {
    if (!isRunning) {
      _initialTime = _currentTime; // Set initial time to current time
      isRunning = true;
      _timer = Timer.periodic(_tickDuration, (timer) {
        _currentTime -= _tickDuration;
        if (_currentTime <= Duration.zero) {
          timer.cancel();
          isRunning = false;
        } else if (_currentTime.inSeconds <= 3) {
          // Play beep sound when there are 3 seconds remaining
          playBeepSound();
        }
        notifyListeners();
      });
      notifyListeners();
    }
  }
  Future<void> playBeepSound() async {
    try {
      // Load the audio file from assets and play it from the beginning
      await audioPlayer.setAsset('assets/sounds/beep-1.wav');
      await audioPlayer.play(); // Start playing from the beginning
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
  void setTime(Duration duration) {
    if (!isRunning) {
      _currentTime = duration;
      _initialTime = duration;
      notifyListeners();
    }
  }

  void pauseTimer() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
      notifyListeners();
    }
  }

  void resetTimer() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
    }
    _currentTime = _initialTime; // Reset to initial duration
    notifyListeners();
  }

  double calculateProgress() {
    // Calculate the progress based on the remaining time and the initial total time
    double progress = 1.0 - (_currentTime.inSeconds / _initialTime.inSeconds);
    return progress.clamp(0.0, 1.0); // Clamp progress between 0.0 and 1.0
  }

}