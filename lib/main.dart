import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_counter_app/StepCounterProvider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'MainScreen.dart';

Future<void> requestPermissions() async {
  if (await Permission.activityRecognition.isDenied) {
    await Permission.activityRecognition.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Stepcounterprovider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Counter App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Mainscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
