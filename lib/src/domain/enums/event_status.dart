enum EventStatus {
  notStarted,
  buyBeer,
  bringBeer,
  drinkBeer,
}

extension EventStatusExtension on EventStatus {
  String get value => const {
        EventStatus.notStarted: 'Not Started',
        EventStatus.buyBeer: 'Buy Beer',
        EventStatus.bringBeer: 'Bring Beer',
        EventStatus.drinkBeer: 'Drink Beer',
      }[this];

  double get percent => const {
        EventStatus.notStarted: 0.0,
        EventStatus.buyBeer: 33.33,
        EventStatus.bringBeer: 66.66,
        EventStatus.drinkBeer: 100.0,
      }[this];
}
