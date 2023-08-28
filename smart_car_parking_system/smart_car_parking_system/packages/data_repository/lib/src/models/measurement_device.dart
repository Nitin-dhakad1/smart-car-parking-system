import 'package:equatable/equatable.dart';

import 'sensor.dart';

class MeasurementDevice extends Equatable {
  final String name;
  final ReadingType readingType;
  final Sensor ph = Sensor(SensorType.ph);
  final Sensor turbidity = Sensor(SensorType.turbidity);
  final Sensor conductivity = Sensor(SensorType.conductivity);
  final Sensor dioxideHumidity = Sensor(SensorType.dioxideHumidity);

  MeasurementDevice({required this.name, required this.readingType});

  @override
  List<Object?> get props => [
        name,
        ph,
        turbidity,
        conductivity,
        dioxideHumidity,
      ];
}
