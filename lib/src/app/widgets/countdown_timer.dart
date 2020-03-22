import 'package:flutter/material.dart';  
import 'package:train_beers/src/domain/extensions/num_extensions.dart';

/// A widget for displaying an up to date countdown to the next train beer event.
class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

/// Manages the state for the CountDownTimer widget.
class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: getSecondsToTrainBeers()),
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
              "Countdown to Train Beers: ${getTimerString(controller.duration, controller.value)}",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black
              ),
            ),
          ],
        );},
    );
  }

  /// Gets a formatted string of the current countdown value.
  /// 
  /// The [newDuration] is calculated by multiplying the supplied [duration]
  /// by the supplied [currentAnimationValue]. The [newDuration] is then
  /// parsed into days, hours, minutes, and seconds. The returned value 
  /// follows the following format: "dd:hh:mm:ss".
  String getTimerString(Duration duration, double currentAnimationValue) {
    Duration newDuration = duration * currentAnimationValue;

    String twoDigitDays = newDuration.inDays.remainder(7).toTwoDigitString();
    String twoDigitHours = newDuration.inHours.remainder(24).toTwoDigitString();
    String twoDigitMinutes = newDuration.inMinutes.remainder(60).toTwoDigitString();
    String twoDigitSeconds = newDuration.inSeconds.remainder(60).toTwoDigitString();

    return "$twoDigitDays:$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Return the number of seconds it is from now until the next train beer event.
  /// 
  /// We look at the current weekday, and set the [daysToAdd] based on that. 
  /// For now we'll assume that train beers always occur on Friday at 4:00 PM ET.
  /// The [nextBeerDate] is derived from the adjusted date from now, and the 
  /// hour, minute, seconds, milliseconds, and microseconds are set to a specific time.
  int getSecondsToTrainBeers() {
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
