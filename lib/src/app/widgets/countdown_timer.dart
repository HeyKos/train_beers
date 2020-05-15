import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

import '../../domain/usecases/countdown_use_case.dart';

/// A widget for displaying a date countdown to the next train beer event.
class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

/// Manages the state for the CountDownTimer widget.
class _CountDownTimerState extends State<CountDownTimer> {
  /// Constructor
  _CountDownTimerState() : countdownUseCase = CountdownUseCase();

  // Members
  final CountdownUseCase countdownUseCase;
  int _currentSeconds;
  Duration _timerDuration;
  StreamSubscription<CountdownTimer> _timerSubscription;

  @override
  void initState() {
    super.initState();
    var countdownSeconds = countdownUseCase.getSecondsToTrainBeers();
    _timerDuration = Duration(seconds: countdownSeconds);
    _currentSeconds = _timerDuration.inSeconds;
    startTimer();
  }

  /// Overrides

  @override
  Widget build(BuildContext context) {
    var currentDuration = Duration(seconds: _currentSeconds);
    var countdown = countdownUseCase.getTimerString(currentDuration);

    return Container(
      color: Colors.grey[800],
      height: 40.0,
      alignment: Alignment.topLeft,
      child: Center(
        child: Text(
          'Train Beer Countdown: $countdown',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Methods

  void onTimerData(CountdownTimer duration) {
    var seconds = _timerDuration.inSeconds - duration.elapsed.inSeconds;
    setState(() => _currentSeconds = seconds);
  }

  void onTimerDone() {
    if (_timerSubscription == null) {
      return;
    }
    _timerSubscription.cancel();
  }

  void startTimer() {
    var countDownTimer = CountdownTimer(
      _timerDuration,
      Duration(seconds: 1),
    );

    // Subscribe to the countdown timer events
    _timerSubscription =
        countDownTimer.listen(onTimerData, onDone: onTimerDone);
  }
}
