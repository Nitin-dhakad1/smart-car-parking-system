part of 'measurement_device_bloc.dart';

abstract class MeasurementDeviceEvent extends Equatable {
  const MeasurementDeviceEvent();

  @override
  List<Object> get props => [];
}

class MeasurementDeviceEventTickStartRequested extends MeasurementDeviceEvent {
  const MeasurementDeviceEventTickStartRequested();
}

class MeasurementDeviceEventReadingRequested extends MeasurementDeviceEvent {
  const MeasurementDeviceEventReadingRequested();
}
