import 'package:equatable/equatable.dart';
import 'package:mock_sensor_data/mock_sensor_data.dart';

class Sensor extends Equatable {
  final SensorType type;
  final MockSensorData _dataGenerator = MockSensorData();

  Sensor(this.type);

  @override
  List<Object?> get props => [type, _dataGenerator];

  double getReading(ReadingType readingType) {
    double val = 0;

    if (readingType == ReadingType.drinking) {
      switch (type) {
        case SensorType.ph:
          val = _dataGenerator.getDrinkablePh();
          break;

        case SensorType.conductivity:
          val = _dataGenerator.getDrinkableConductivity().toDouble();
          break;

        case SensorType.turbidity:
          val = _dataGenerator.getDrikableTurbidity().toDouble();
          break;

        case SensorType.dioxideHumidity:
          val = _dataGenerator.getDrinkableDioxideHumidity().toDouble();
          break;

        default:
          throw UnimplementedError();
      }
    } else if (readingType == ReadingType.irrigation) {
      switch (type) {
        case SensorType.ph:
          val = _dataGenerator.getIrrigationPh();
          break;

        case SensorType.conductivity:
          val = _dataGenerator.getIrrigationConductivity().toDouble();
          break;

        case SensorType.turbidity:
          val = _dataGenerator.getIrrigationTurbidity().toDouble();
          break;

        case SensorType.dioxideHumidity:
          val = _dataGenerator.getIrrigationDioxideHumidity().toDouble();
          break;

        default:
          throw UnimplementedError();
      }
    }
    return val;
  }

  CleanlinessLevel getCleanlinessLevel(double readingVal) {
    switch (type) {
      case SensorType.ph:
        if (6.5 <= readingVal && readingVal <= 8.5)
          return CleanlinessLevel.drinkable;
        // TODO
        else if (6 <= readingVal && readingVal <= 9)
          return CleanlinessLevel.irrigatable;
        return CleanlinessLevel.dirty;

      case SensorType.turbidity:
        if (1 <= readingVal && readingVal <= 5)
          return CleanlinessLevel.drinkable;
        // TODO
        else if (readingVal < 1 || readingVal > 5)
          return CleanlinessLevel.irrigatable;
        return CleanlinessLevel.dirty;

      case SensorType.conductivity:
        if (200 <= readingVal && readingVal <= 800)
          return CleanlinessLevel.drinkable;
        // TODO
        else if (100 <= readingVal && readingVal <= 900)
          return CleanlinessLevel.irrigatable;
        return CleanlinessLevel.dirty;

      case SensorType.dioxideHumidity:
        if (40 <= readingVal && readingVal <= 100)
          return CleanlinessLevel.drinkable;
        // TODO
        else if (20 <= readingVal && readingVal <= 100)
          return CleanlinessLevel.irrigatable;
        return CleanlinessLevel.dirty;

      default:
        throw UnimplementedError();
    }
  }
}

enum SensorType {
  ph,
  turbidity,
  conductivity,
  dioxideHumidity,
}

enum ReadingType {
  drinking,
  irrigation,
}

enum CleanlinessLevel {
  drinkable,
  irrigatable,
  dirty,
}
