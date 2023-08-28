import 'dart:math';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_repository/data_repository.dart';

import '../ticker.dart';

part 'measurement_device_event.dart';
part 'measurement_device_state.dart';

List<CleanlinessLevel> _cleanlinessLevels = [
  CleanlinessLevel.drinkable,
  CleanlinessLevel.irrigatable,
  CleanlinessLevel.dirty
];

class MeasurementDeviceBloc
    extends Bloc<MeasurementDeviceEvent, MeasurementDeviceState> {
  final Ticker _ticker;
  StreamSubscription<bool>? _tickerSubscription;
  final MeasurementDevice _device;

  MeasurementDeviceBloc({
    required MeasurementDevice device,
    required Ticker ticker,
  })  : _device = device,
        _ticker = ticker,
        super(const MeasurementDeviceStateInitial()) {
    on<MeasurementDeviceEventTickStartRequested>(_onStarted);
    on<MeasurementDeviceEventReadingRequested>(_onReadingsRequested);
  }

  void _onReadingsRequested(MeasurementDeviceEventReadingRequested event,
      Emitter<MeasurementDeviceState> emit) {
    double ph = _device.ph.getReading(_device.readingType);
    double turbidity = _device.turbidity.getReading(_device.readingType);
    double conductivity = _device.conductivity.getReading(_device.readingType);
    double dioxide = _device.dioxideHumidity.getReading(_device.readingType);

    List<Sensor> sensors = [
      _device.ph,
      _device.turbidity,
      _device.conductivity,
      _device.dioxideHumidity
    ];
    List<double> readings = [ph, turbidity, conductivity, dioxide];
    Map<SensorType, CleanlinessLevel> sensorCleanlinessLevels = {};

    int cleanlinessLevelIdx = 0;
    for (int i = 0; i < readings.length; i++) {
      CleanlinessLevel level = sensors[i].getCleanlinessLevel(readings[i]);
      sensorCleanlinessLevels.putIfAbsent(sensors[i].type, () => level);
      cleanlinessLevelIdx = max(
        cleanlinessLevelIdx,
        _cleanlinessLevels.indexOf(level),
      );
    }

    emit(MeasurementDeviceStateLoaded(
      device: _device,
      readings: {
        _device.ph.type: ph,
        _device.turbidity.type: turbidity,
        _device.conductivity.type: conductivity,
        _device.dioxideHumidity.type: dioxide,
      },
      sensorCleanlinessLevels: sensorCleanlinessLevels,
      worstCleanlinessLevel: _cleanlinessLevels[cleanlinessLevelIdx],
    ));
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(MeasurementDeviceEventTickStartRequested event,
      Emitter<MeasurementDeviceState> emit) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(10000).listen((_) => add(
          const MeasurementDeviceEventReadingRequested(),
        ));
  }
}
