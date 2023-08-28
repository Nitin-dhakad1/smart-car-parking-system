import 'dart:math';

import 'package:equatable/equatable.dart';

class MockSensorData extends Equatable {
  final Random _rng = Random();

  MockSensorData();

  @override
  List<Object?> get props => [_rng];

  double getDrinkablePh() {
    double val = _rng.nextDouble();

    // pH between 6.5 & 8.5 is drinkable
    return 2 * val + 6.5;
  }

  double getIrrigationPh() {
    // TODO
    double val = _rng.nextDouble();
    return 2 * val + 7;
  }

  int getDrikableTurbidity() {
    return _rng.nextInt(4) + 1;
  }

  int getIrrigationTurbidity() {
    // TODO
    return _rng.nextInt(2) + 1;
  }

  int getDrinkableConductivity() {
    return _rng.nextInt(600) + 200;
  }

  int getIrrigationConductivity() {
    // TODO
    return _rng.nextInt(200);
  }

  int getDrinkableDioxideHumidity() {
    return _rng.nextInt(60) + 40;
  }

  int getIrrigationDioxideHumidity() {
    // TODO
    return _rng.nextInt(40);
  }
}
