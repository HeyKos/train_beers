// Import the test package and Counter class
import 'package:clock/clock.dart';
import 'package:test/test.dart';
import 'package:train_beers/src/domain/usecases/countdown_use_case.dart';

void main() {
  group('shouldDisplayCountdown', () {
    test('Should return true when day of week is Monday', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 23));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });

    test('Should return true when day of week is Tuesday', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 24));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });

    test('Should return true when day of week is Wednesday', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 25));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });

    test('Should return true when day of week is Thursday', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 26));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });

    test('''Should return true when day of week is Friday AND time is earlier
    than 4:00 PM''', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 27, 15, 59));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });

    test('''Should return true when day of week is Friday AND time is later
    than 5:00 PM''', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 27, 17, 1));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });

    test('Should return false when day of week is Friday AND time is 4:00 PM',
        () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 27, 16, 0));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, false);
    });

    test('Should return false when day of week is Friday AND time is 5:00 PM',
        () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 27, 17, 0));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, false);
    });

    test('''Should return false when day of week is Friday AND time is between
    4:00 PM and 5:00 PM''', () {
      // Arrange
      final mockClock = Clock.fixed(DateTime(2020, 3, 27, 16, 30));

      final useCase = CountdownUseCase(clock: mockClock);

      // Act
      var result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, false);
    });
  });
}
