import 'package:equatable/equatable.dart';

import 'models/models.dart';

class DataRepository extends Equatable {
  final List<MeasurementDevice> devices;

  DataRepository({List<MeasurementDevice>? devices})
      : this.devices = devices ??
            [
              MeasurementDevice(
                  name: 'Garden', readingType: ReadingType.irrigation),
              MeasurementDevice(
                  name: 'Home Water Tank', readingType: ReadingType.drinking),
              MeasurementDevice(
                  name: 'Farm Tubewell', readingType: ReadingType.irrigation),
            ];

  @override
  List<Object?> get props => [devices];
}
