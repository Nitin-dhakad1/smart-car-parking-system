class Ticker {
  const Ticker();
  Stream<bool> tick(int readings) {
    return Stream.periodic(const Duration(seconds: 2), (x) => true)
        .take(readings);
  }
}
