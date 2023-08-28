import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_repository/data_repository.dart';

import '../../ticker.dart';
import '../../measurement_device/measurement_device.dart';
import '../../constants/constants.dart';
import '../../bloc/measurement_device_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(HomePageConstants.appBarTitle),
      ),
      body: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: kdefaultPadding),
      child: ListView.builder(
          itemBuilder: (context, i) {
            return BlocProvider(
              create: (context) => MeasurementDeviceBloc(
                device: context.read<DataRepository>().devices[i],
                ticker: const Ticker(),
              )
                ..add(const MeasurementDeviceEventTickStartRequested())
                ..add(const MeasurementDeviceEventReadingRequested()),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kdefaultPadding,
                  vertical: kdefaultPadding * 0.33,
                ),
                child: MeasurementDeviceTile(),
              ),
            );
          },
          itemCount: context.read<DataRepository>().devices.length),
    ));
  }
}

class MeasurementDeviceTile extends StatelessWidget {
  const MeasurementDeviceTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementDeviceBloc, MeasurementDeviceState>(
      builder: (context, state) {
        if (state is MeasurementDeviceStateInitial) {
          return const Card(child: Center(child: CircularProgressIndicator()));
        } else if (state is MeasurementDeviceStateLoaded) {
          Color drinkColor = Colors.transparent;
          Color irrigateColor = Colors.transparent;

          String drinkLabel = '';
          String irrigateLabel = '';

          if (state.worstCleanlinessLevel == CleanlinessLevel.drinkable) {
            drinkLabel = MeasurementDeviceConstants.drinkableLabel;
            irrigateLabel = MeasurementDeviceConstants.irrigatableLabel;
            drinkColor = ContextColors.acceptable;
            irrigateColor = ContextColors.acceptable;
          } else if (state.worstCleanlinessLevel ==
              CleanlinessLevel.irrigatable) {
            drinkLabel = MeasurementDeviceConstants.notDrinkableLabel;
            irrigateLabel = MeasurementDeviceConstants.irrigatableLabel;
            drinkColor = ContextColors.unacceptable;
            irrigateColor = ContextColors.acceptable;
          } else {
            drinkLabel = MeasurementDeviceConstants.notDrinkableLabel;
            irrigateLabel = MeasurementDeviceConstants.notIrrigatableLabel;
            drinkColor = ContextColors.unacceptable;
            irrigateColor = ContextColors.unacceptable;
          }

          return Card(
            color: Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).colorScheme.shadow,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            elevation: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                MeasurementDeviceBloc bloc =
                    context.read<MeasurementDeviceBloc>();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MeasurementDevicePage(
                    bloc: bloc,
                  );
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(kdefaultPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'device-name-${state.device.name}',
                      child: Text(
                        state.device.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(top: kdefaultPadding)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          drinkLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: drinkColor),
                        ),
                        Text(
                          irrigateLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: irrigateColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Card(
            child: Text(MeasurementDeviceConstants.unknownStateLabel),
          ),
        );
      },
    );
  }
}
