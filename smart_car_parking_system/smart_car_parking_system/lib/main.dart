import 'package:flutter/material.dart';

import 'package:data_repository/data_repository.dart';

import 'app.dart';

void main() async {
  DataRepository repository = DataRepository();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    WaterApp(
      dataRepository: repository,
    ),
  );
}
