import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stepcounterprovider with ChangeNotifier {
  int _steps = 0;
  late StreamSubscription<StepCount> _subscription;

  Stepcounterprovider() {
    _initPedometer();
  }

  int get steps => _steps;

  Future<void> _initPedometer() async {
    // Initialize the pedometer
    _subscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );

    // Fetch initial step count from persistent storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _steps = prefs.getInt('steps') ?? 0;
    notifyListeners();
  }

  void _onStepCount(StepCount event) async {
    print('New step count: ${event.steps}');
    _steps = event.steps;

    // Store the current step count in persistent storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', _steps);

    notifyListeners();
  }

  void _onError(error) {
    print('Pedometer Error: $error');
  }

  void _onDone() {
    print('Pedometer done');
  }

  void resetSteps() async {
    _steps = 0;
    notifyListeners();

    // Reset persistent storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', _steps);

    // Optionally, restart the pedometer subscription after resetting
    _subscription.cancel();
    _initPedometer();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
