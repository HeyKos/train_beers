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
      bool result = useCase.shouldDisplayCountdown();

      // Assert
      expect(result, true);
    });
  });
}