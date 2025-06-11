import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // ✅ حفظ بيانات المستخدم كاملة مع الاسم والصورة كـ متغيرات منفصلة
  static Future<void> saveUserData({
    required Map<String, dynamic> userData,
    required String username,
    required String profileImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(userData));
    await prefs.setString('username', username);
    await prefs.setString('profile_image', profileImagePath);
  }

  // ✅ استرجاع بيانات المستخدم كاملة (الخريطة الأصلية)
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // ✅ استرجاع الاسم فقط
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // ✅ استرجاع مسار الصورة فقط
  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image');
  }

  // ✅ معرفة إذا كان Patient أو Companion
  static Future<bool?> isPatient() async {
    final data = await getUserData();
    if (data != null) {
      return data['patientId'] == null;
    }
    return null;
  }
// ✅ إرجاع الـ patientId الفعلي (لو Patient نرجع id، لو Companion نرجع patientId)
  static Future<String?> getEffectivePatientId() async {
    final data = await getUserData();
    if (data == null) return null;

    if (data['patientId'] == null) {
      // هو مريض، نرجّع الـ id الخاص به
      return data['id']?.toString();
    } else {
      // هو مرافق، نرجّع patientId المرتبط به
      return data['patientId']?.toString();
    }
  }

  // ✅ حذف كل بيانات المستخدم
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.remove('username');
    await prefs.remove('profile_image');
  }
}
