import 'package:flutter/material.dart';  
import 'dart:math' as math;


class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    // // return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    // return '${duration.inDays}:${duration.inHours}:${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
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
    ThemeData themeData = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child:
              Container(
                color: Colors.amber,
                height:
                controller.value * MediaQuery.of(context).size.height,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: CustomPaint(
                                  painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  )),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Count Down Timer",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    timerString,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return FloatingActionButton.extended(
                            onPressed: () {
                              if (controller.isAnimating)
                                controller.stop();
                              else {
                                controller.reverse(
                                    from: controller.value == 0.0
                                        ? 1.0
                                        : controller.value);
                              }
                            },
                            icon: Icon(controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow),
                            label: Text(
                                controller.isAnimating ? "Pause" : "Play"));
                      }),
                ],
              ),
            ),
          ],
        );
      });
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

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}