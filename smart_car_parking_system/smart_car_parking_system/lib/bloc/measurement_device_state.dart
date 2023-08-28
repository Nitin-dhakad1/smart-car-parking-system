part of 'measurement_device_bloc.dart';

abstract class MeasurementDeviceState extends Equatable {
  const MeasurementDeviceState();

  @override
  List<Object> get props => [];
}

class MeasurementDeviceStateInitial extends MeasurementDeviceState {
  const MeasurementDeviceStateInitial();

  @override
  List<Object> get props => [];
}

class MeasurementDeviceStateLoaded extends MeasurementDeviceState {
  final MeasurementDevice device;
  final Map<SensorType, double> readings;
  final Map<SensorType, CleanlinessLevel> sensorCleanlinessLevels;
  final CleanlinessLevel worstCleanlinessLevel;

  const MeasurementDeviceStateLoaded({
    required this.device,
    required this.readings,
    required this.sensorCleanlinessLevels,
    required this.worstCleanlinessLevel,
  });

  @override
  List<Object> get props => [readings, worstCleanlinessLevel];
}
