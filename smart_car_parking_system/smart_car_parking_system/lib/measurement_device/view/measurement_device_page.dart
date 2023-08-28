import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_repository/data_repository.dart';

import '../../bloc/measurement_device_bloc.dart';
import '../../constants/constants.dart';

class MeasurementDevicePage extends StatelessWidget {
  final MeasurementDeviceBloc _bloc;
  const MeasurementDevicePage({
    super.key,
    required MeasurementDeviceBloc bloc,
  }) : _bloc = bloc;

  @override
  Widget build(BuildContext context) {
    // return _MeasurementDevicePageView(_bloc.state);
    return BlocProvider<MeasurementDeviceBloc>.value(
      value: _bloc,
      child: const _MeasurementDevicePageView(),
    );
  }
}

class _MeasurementDevicePageView extends StatelessWidget {
  // final state;
  const _MeasurementDevicePageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementDeviceBloc, MeasurementDeviceState>(
      builder: (context, state) {
        if (state is MeasurementDeviceStateLoaded) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Hero(
                tag: 'device-name-${state.device.name}',
                child: Text(
                  state.device.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            body: ListView(
              children: [
                DetailTile(
                  name: 'pH',
                  val: state.readings[SensorType.ph]!,
                  cleanlinessLevel:
                      state.sensorCleanlinessLevels[SensorType.ph]!,
                  unit: '',
                  precision: 2,
                ),
                DetailTile(
                  name: 'Turbidity',
                  val: state.readings[SensorType.turbidity]!,
                  cleanlinessLevel:
                      state.sensorCleanlinessLevels[SensorType.turbidity]!,
                  unit: 'in NTUs',
                ),
                DetailTile(
                  name: 'CO2',
                  val: state.readings[SensorType.dioxideHumidity]!,
                  cleanlinessLevel: state
                      .sensorCleanlinessLevels[SensorType.dioxideHumidity]!,
                  unit: 'in mg/L',
                ),
                DetailTile(
                  name: 'Conductivity',
                  val: state.readings[SensorType.conductivity]!,
                  cleanlinessLevel:
                      state.sensorCleanlinessLevels[SensorType.conductivity]!,
                  unit: 'in μSiemens',
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class DetailTile extends StatelessWidget {
  final IconData? iconData;
  final CleanlinessLevel cleanlinessLevel;
  final String name;
  final String unit;
  final double val;
  final int precision;

  final String trailingString;
  final Color trailingColor;

  const DetailTile(
      {super.key,
      required this.val,
      required this.name,
      this.iconData,
      required this.cleanlinessLevel,
      required this.unit,
      this.precision = 0})
      : trailingString = cleanlinessLevel == CleanlinessLevel.drinkable
            ? 'Drinkable'
            : cleanlinessLevel == CleanlinessLevel.irrigatable
                ? 'Irrigatable'
                : 'Dirty',
        trailingColor = cleanlinessLevel == CleanlinessLevel.drinkable
            ? ContextColors.acceptable
            : cleanlinessLevel == CleanlinessLevel.irrigatable
                ? ContextColors.medium
                : ContextColors.unacceptable;

  @override
  Widget build(BuildContext context) {
    final TextStyle textTheme = Theme.of(context).textTheme.headlineSmall!;

    return Padding(
      padding: const EdgeInsets.only(
        left: kdefaultPadding,
        right: kdefaultPadding,
        top: kdefaultPadding,
      ),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).colorScheme.shadow,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kdefaultPadding),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: RichText(
              text: TextSpan(
                text: '$name: ',
                style: textTheme.copyWith(
                    color: Theme.of(context).colorScheme.primary),
                children: [
                  TextSpan(
                    text: val.toStringAsFixed(precision),
                    style: textTheme.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ],
              ),
            ),
            subtitle: Text(unit),
            trailing: Text(trailingString,
                style: textTheme.copyWith(color: trailingColor)),
          ),
        ),
      ),
    );
  }
}
