import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:data_repository/data_repository.dart';

import 'home/home.dart';

class WaterApp extends StatelessWidget {
  final DataRepository _dataRepository;

  const WaterApp({
    super.key,
    required DataRepository dataRepository,
  }) : _dataRepository = dataRepository;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return RepositoryProvider.value(
          value: _dataRepository,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: lightDynamic,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkDynamic,
              useMaterial3: true,
            ),
            themeMode: ThemeMode.system,
            home: const HomePage(),
            // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        );
      },
    );
  }
}
