import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ECGStatus { idle, loading, result }

class ECGProvider extends ChangeNotifier {
  ECGStatus _status = ECGStatus.idle;
  String _result = "No result";

  ECGStatus get status => _status;
  String get result => _result;

  Future<void> startMeasurement() async {
    _status = ECGStatus.loading;
    _result = "Checking...";
    notifyListeners();

    final url = Uri.parse('https://renderappecgclassifiy.onrender.com/predict');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // استخراج prediction فقط
        final prediction = data['prediction'] ?? "Unknown";
        _result = prediction;
        _status = ECGStatus.result;
      } else {
        _result = "Failed: ${response.statusCode}";
        _status = ECGStatus.result;
      }
    } catch (e) {
      _result = "Error: $e";
      _status = ECGStatus.result;
    }

    notifyListeners();
  }

  void reset() {
    _status = ECGStatus.idle;
    _result = "No result";
    notifyListeners();
  }
}
