import 'package:clock/clock.dart';

import '../extensions/num_extensions.dart';

/// This class encapsulates logic related to the train beer countdown timer.
/// It intentionally bypasses the standard [UseCase] class structure, since
/// it doesn't need to rely on returning a [Stream] since methods in this use
/// case will be synchronous. This is an experiment to see what options we have
/// encapsulating business logic related to a business concept that doesn't
/// relate to a specific [Entity].
class CountdownUseCase {
  /// Members
  final Clock clock;

  /// Constructor
  CountdownUseCase({this.clock = const Clock()});

  /// Return the number of seconds it is from now until the next train beer
  /// event.  We look at the current weekday, and set the [daysToAdd] based on
  /// that. For now we'll assume that train beers always occur on Friday at
  /// 4:00 PM ET. The [nextBeerDate] is derived from the adjusted date from now,
  /// and the hour, minute, seconds, milliseconds, and microseconds are set to a
  /// specific time.
  int getSecondsToTrainBeers() {
    var now = clock.now();

    var daysToAdd = 0;
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
        } else {
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
    now = now.add(Duration(days: daysToAdd));
    // Create a new date basing the year, month, and day off of our adjusted
    // [now] DateTime object. The time will be explicitly set to 4:00 PM.
    var nextBeerDate = DateTime(now.year, now.month, now.day, 16, 0, 0, 0, 0);

    return nextBeerDate.difference(clock.now()).inSeconds;
  }

  /// Gets a formatted string of the current countdown value. The [duration] is
  /// parsed into days, hours, minutes, and seconds. The returned value follows
  /// the following format: "dd:hh:mm:ss".
  String getTimerString(Duration duration) {
    var twoDigitDays = duration.inDays.remainder(7).toTwoDigitString();
    var twoDigitHours = duration.inHours.remainder(24).toTwoDigitString();
    var twoDigitMinutes = duration.inMinutes.remainder(60).toTwoDigitString();
    var twoDigitSeconds = duration.inSeconds.remainder(60).toTwoDigitString();

    return "$twoDigitDays:$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Determines if a countdown time should be displayed. Returns [true] if the
  /// day of the week is not Friday, or the current time is not between 4:00 PM
  /// and 5:00 PM.
  bool shouldDisplayCountdown() {
    var now = clock.now();
    if (now.weekday != 5) {
      return true;
    }

    return now.hour < 16 || (now.hour >= 17 && now.minute > 0);
  }
}
