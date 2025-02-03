import 'package:admin_web_app_sp/services/provider/department_provider.dart';
import 'package:admin_web_app_sp/services/provider/faculty_provider.dart';
import 'package:admin_web_app_sp/services/provider/students_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/authentication/login_auth_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Add this line for web initialization
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FacultyProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentsProvider()),
        ChangeNotifierProvider(create: (_) => StudentsListProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginAuthPage(),
      routes: {
        '/DashboardScreen': (context) => DashboardScreen(),
      },
    );
  }
}
