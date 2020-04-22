import 'package:flutter/material.dart';

import '../../domain/usecases/countdown_use_case.dart';

/// A widget for displaying a date countdown to the next train beer event.
class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

/// Manages the state for the CountDownTimer widget.
class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  /// Constructor
  _CountDownTimerState() : countdownUseCase = CountdownUseCase();

  // Members
  final CountdownUseCase countdownUseCase;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: countdownUseCase.getSecondsToTrainBeers()),
    );
  }

  /// Overrides

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start the timer.
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    var countdown =
        countdownUseCase.getTimerString(controller.duration, controller.value);

    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
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
        });
  }
}
