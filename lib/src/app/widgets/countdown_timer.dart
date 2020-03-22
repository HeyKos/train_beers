import 'package:flutter/material.dart';  

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitDays = twoDigits(duration.inDays.remainder(7));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitDays:$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: getDurationToTrainBeersInSeconds()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Start the timer.
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Countdown to Train Beers: $timerString",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black
              ),
            ),
          ],
        );},
    );
  }

  /// Determine how many seconds it is from now until next Friday at 4:00 PM.
  int getDurationToTrainBeersInSeconds() {
    DateTime now =  DateTime.now();

    int daysToAdd = 0;
    switch (now.weekday) {
      case 1: // Monday
        daysToAdd = 4;
        break;
      case 2: // Tuesday
        daysToAdd = 3;
        break;
      case 3: // Wednesday
        daysToAdd = 2;
        break;
      case 4: // Thursday
        daysToAdd = 1;
        break;
      case 5: // Friday
        if (now.hour < 16) {
          daysToAdd = 0;
        }
        else {
          daysToAdd = 7;
        }
        break;
      case 6: // Saturday
        daysToAdd = 6;
        break;
      case 7: // Sunday
      default: 
        daysToAdd = 5;
        break;
    }
    // Update now to the next Friday.
    now = now.add(new Duration(days: daysToAdd));
    // Create a new date basing the year, month, and day off of our adjusted [now] DateTime object.
    // The time will be explicitly set to 4:00 PM.
    DateTime nextBeerDate = new DateTime(now.year, now.month, now.day, 17, 0, 0, 0, 0);
    
    return nextBeerDate.difference(DateTime.now()).inSeconds;
  }

}
