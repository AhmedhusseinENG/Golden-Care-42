import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:golden_care_2/profile_screen/enter_profile_screen.dart';
import 'package:golden_care_2/profile_screen/help_screen.dart';
import 'package:golden_care_2/profile_screen/privacy_policy.dart';
import 'package:golden_care_2/profile_screen/profile_screen.dart';
import 'package:golden_care_2/profile_screen/settings/notification_settings.dart';
import 'package:golden_care_2/profile_screen/settings/password_manager.dart';
import 'package:golden_care_2/profile_screen/settings/settings.dart';
import 'package:golden_care_2/signup_screen.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, MultiProvider;

import 'Ecg_model/ECG_screen.dart';
import 'Ecg_model/ecg_provider.dart';
import 'brain_tumor/brain_tumor.dart';
import 'checker/check_screen.dart';
import 'checker/choose_issue.dart';
import 'checker/types_symptoms.dart';
import 'doctor_details/doctor_list.dart';
import 'doctor_details/doctor_number.dart';
import 'firebase_options.dart';
import 'forgot_ password_screen/forgot_password.dart';
import 'forgot_ password_screen/reset_password.dart';
import 'forgot_ password_screen/set_password.dart';
import 'home_screen/HealthDataProvider.dart';
import 'home_screen/home_screen.dart';
import 'medicine_reminder/add_medicine.dart';
import 'medicine_reminder/medicine_details.dart';
import 'notifications/companion_notification.dart';
import 'notifications/patient_notification.dart';
import 'onboarding_screen.dart';
import 'WelcomeScreen.dart';
import 'login/loginContinue_screen.dart';
import 'login/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // هذه الإضافة مهمة
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ECGProvider()),
        ChangeNotifierProvider(create: (_) => HealthDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: OnboardingScreen.routName,
      routes: {
        WelcomeScreen.routName: (context) => WelcomeScreen(),
        OnboardingScreen.routName: (context) => OnboardingScreen(),
        LoginScreen.routName: (context) => LoginScreen(),
        LoginContinueScreen.routName: (context) => LoginContinueScreen(),
        SignupScreen.routName: (context) => SignupScreen(),
        ForgotPasswordScreen.routName: (context) => ForgotPasswordScreen(),
        ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
        SetPassword.routeName: (context) => SetPassword(),
        HomeScreen.routName: (context) => HomeScreen(),
        ECGScreen.routName: (context) => ECGScreen(),
        ProfileScreen.routName: (context) => ProfileScreen(),
        PrivacyPolicyScreen.routName: (context) => PrivacyPolicyScreen(),
        SettingsScreen.routName: (context) => SettingsScreen(),
        NotificationSettingsScreen.routName: (context) => NotificationSettingsScreen(),
        PasswordManagerScreen.routName: (context) => PasswordManagerScreen(),
        HelpCenterScreen.routName: (context) => HelpCenterScreen(),
        EnterProfileScreen.routName: (context) => EnterProfileScreen(isPatient: false),
        CheckScreen.routName: (context) => CheckScreen(),
        TypesSymptoms.routName: (context) => TypesSymptoms(),
        ChooseIssueScreen.routName: (context) => ChooseIssueScreen(),
        BrainTumerScreen.routeName: (context) => BrainTumerScreen(),
        DoctorListScreen.routName: (context) => DoctorListScreen(),
        DoctorNumber.routName: (context) => DoctorNumber(),
        PatientNotificationScreen.routName: (context) => PatientNotificationScreen(),
        CompanionNotificationScreen.routName: (context) => CompanionNotificationScreen(),
        AddMedicineScreen.routName: (context) => AddMedicineScreen(isEdit: true),
        MedicineDetailsScreen.routName: (context) => MedicineDetailsScreen(),
      },
    );
  }
}