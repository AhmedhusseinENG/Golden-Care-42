import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HealthDataProvider with ChangeNotifier {
  double heartRate = 0.0;
  double spo2 = 98.0;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('/patients/patient_123/readings/latest'); // تأكد من مسار المريض المناسب

  HealthDataProvider() {
    _loadHealthData();
  }


  Future<void> _loadHealthData() async {
    try {
      isLoading = true;
      notifyListeners();

      DatabaseEvent event = await _dbRef.once();
      final data = event.snapshot.value as Map<dynamic, dynamic>;


      heartRate = (data['heart_rate'] != null && data['heart_rate'] is num)
          ? (data['heart_rate'] as num).toDouble()
          : 0.0;
      spo2 = (data['spo2'] != null && data['spo2'] is num)
          ? (data['spo2'] as num).toDouble()
          : 98.0;

      isLoading = false;
      notifyListeners();


      _dbRef.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        print('Updated heart rate: ${data['heart_rate']}');
        print('Updated spo2: ${data['spo2']}');


        heartRate = (data['heart_rate'] != null && data['heart_rate'] is num)
            ? (data['heart_rate'] as num).toDouble()
            : 0.0;

        spo2 = (data['spo2'] != null && data['spo2'] is num)
            ? (data['spo2'] as num).toDouble()
            : 98.0;

        notifyListeners();
      });

    } catch (e) {
      hasError = true;
      errorMessage = 'فشل تحميل بيانات الصحة: $e';
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> refreshHealthData() async {
    try {
      isLoading = true;
      notifyListeners();

      DatabaseEvent event = await _dbRef.once();
      final data = event.snapshot.value as Map<dynamic, dynamic>;


      heartRate = (data['heart_rate'] != null && data['heart_rate'] is num)
          ? (data['heart_rate'] as num).toDouble()
          : 0.0;

      spo2 = (data['spo2'] != null && data['spo2'] is num)
          ? (data['spo2'] as num).toDouble()
          : 98.0;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = 'فشل تحديث بيانات الصحة: $e';
      isLoading = false;
      notifyListeners();
    }
  }
}