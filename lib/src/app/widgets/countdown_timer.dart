import 'package:flutter/material.dart';
import 'package:train_beers/src/domain/usecases/countdown_use_case.dart';

/// A widget for displaying an up to date countdown to the next train beer event.
class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

/// Manages the state for the CountDownTimer widget.
class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  // Members
  final CountdownUseCase countdownUseCase;
  AnimationController controller;

  /// Constructor
  _CountDownTimerState(): countdownUseCase = CountdownUseCase();

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
  Widget build(BuildContext context) {
    // Start the timer.
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Countdown to Beers:",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${countdownUseCase.getTimerString(controller.duration, controller.value)}",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue
                    ),
                  ),
                ],
              ),
            ],
          ),
        );},
    );
  }
}
