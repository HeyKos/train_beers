enum EventStatus {
  buyBeer,
  bringBeer,
  drinkBeer,
}

extension EventStatusExtension on EventStatus {
  String get value => const {
    EventStatus.buyBeer: 'Buy Beer',
    EventStatus.bringBeer: 'Bring Beer',
    EventStatus.drinkBeer: 'Drink Beer',
  }[this];
}
