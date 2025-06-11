import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_preferences_helper.dart';
import 'package:http_parser/http_parser.dart'; // لـ MediaType
import 'package:mime/mime.dart'; // لـ lookupMimeType

/// ... جميع الـ imports كما هي ...

class AuthService {
  final _storage = FlutterSecureStorage();
  final String baseUrl = "https://migration.runasp.net/api/Auth";

  // ✅ التسجيل كمريض
  Future<String?> registerPatient({
    required String username,
    required String email,
    required String password,
    required String gender,
    required File image,
  }) async {
    final url = Uri.parse('$baseUrl/register/patient');

    var request = http.MultipartRequest('POST', url)
      ..headers['Content-Type'] = 'multipart/form-data'
      ..fields['username'] = username
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['gender'] = gender;

    var imageBytes = await image.readAsBytes();
    var imageMultipart = http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: image.path.split('/').last,
      contentType: MediaType.parse(lookupMimeType(image.path)!),
    );
    request.files.add(imageMultipart);

    try {
      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          final data = jsonDecode(responseBody);
          final patientId = data['patientId'];
          if (patientId != null) {
            // ✅ حفظ البيانات مع تحديد الـ role
            await SharedPreferencesHelper.saveUserData(
              userData: {
                'username': username,
                'email': email,
                'gender': gender,
                'image': image.path,
                'patientId': patientId.toString(),
                'role': 'patient',
              },
              username: username,
              profileImagePath: image.path,
            );


            final storedUserData = await SharedPreferencesHelper.getUserData();
            print('Stored user data: $storedUserData');

            return patientId.toString();
          } else {
            print('patientId not found in response');
            return 'Patient ID not found in response';
          }
        } else {
          print('Response is not JSON: $responseBody');
          return responseBody;
        }
      } else {
        print('Registration failed: ${response.statusCode}');
        return 'Registration failed';
      }
    } catch (e) {
      print('Error: $e');
      return 'Error during registration: $e';
    }
  }

  // ✅ التسجيل كمرافق
  Future<bool> registerCompanion({
    required String username,
    required String email,
    required String password,
    required String gender,
    required String patientId,
    File? image,
  }) async {
    final url = Uri.parse('$baseUrl/register/companion');

    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['username'] = username
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['gender'] = gender
        ..fields['patientId'] = patientId;

      if (image != null) {
        var imageBytes = await image.readAsBytes();
        var imageMultipart = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: image.path.split('/').last,
          contentType: MediaType.parse(lookupMimeType(image.path)!),
        );
        request.files.add(imageMultipart);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          final data = jsonDecode(responseBody);

          // ✅ حفظ البيانات مع تحديد الـ role
          await SharedPreferencesHelper.saveUserData(
            userData: {
              'username': username,
              'email': email,
              'gender': gender,
              'image': image?.path ?? '',
              'patientId': patientId,
              'role': 'companion',
            },
            username: username,
            profileImagePath: image?.path ?? '',
          );


          final storedUserData = await SharedPreferencesHelper.getUserData();
          print('Stored companion data: $storedUserData');

          return true;
        } else {
          print('Response is not JSON');
          return false;
        }
      } else {
        print("Registration failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error during companion registration: $e");
      return false;
    }
  }

  // ✅ تسجيل الدخول
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("username") &&
            data.containsKey("id") &&
            data.containsKey("email") &&
            data.containsKey("gender") &&
            data.containsKey("image")) {

          // ✅ تحديد الـ role قبل الحفظ
          data['role'] = data['patientId'] == null ? 'patient' : 'companion';

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userData', jsonEncode(data));

          print("✅ Logged in as: ${data['role']}");
          print("✅ Stored user data: ${jsonEncode(data)}");

          return data;
        } else {
          print("Missing some fields in response");
          return null;
        }
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  Future<String?> getPatientId() async {
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData != null && userData.containsKey('patientId')) {
      return userData['patientId'];
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    await SharedPreferencesHelper.clearUserData();
  }
}
