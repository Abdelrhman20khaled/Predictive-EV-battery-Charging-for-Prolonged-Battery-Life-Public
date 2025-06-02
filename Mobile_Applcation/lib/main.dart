import 'package:ev_logger/screens/history.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/login.dart';
import 'screens/soh_screen.dart';
import 'screens/soc_screen.dart';
import 'package:provider/provider.dart';
import 'package:ev_logger/mqtt_services.dart';
import 'screens/user_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://acqlvlymzuvktrmvfyld.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFjcWx2bHltenV2a3RybXZmeWxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE0NDEwOTQsImV4cCI6MjA1NzAxNzA5NH0.S3O0XHxz6RprXp6JOP0ghOaGuJTR1zuO84ufS24vPTg',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => MqttService()..connect(),
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
      initialRoute: 'login',
      routes: {
        'login': (context) => const Login(),
        'home': (context) => const MyHomePage(),
        'soh': (context) => const SoHScreen(),
        'soc': (context) => const SoCScreen(),
        'user_profile': (context) => const UserProfile(),
        'history': (context) => const HistoryScreen(),
      },
    );
  }
}
