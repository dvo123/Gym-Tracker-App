import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/pages/auth_page.dart';
import 'package:my_first_flutter_project/pages/home_page.dart';
import 'package:my_first_flutter_project/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_first_flutter_project/user%20data/workout_data.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize hive
  await Hive.initFlutter();
  await Hive.openBox("workout_database_");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            background: Color.fromARGB(255, 28, 28, 28),
            primary: Color.fromARGB(255, 33, 33, 33),
            secondary: Color.fromARGB(255, 79, 79, 79),
            inversePrimary: Colors.white,
          ),
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: Colors.black, // Your desired body text color
            displayColor: Colors.black, // Your desired display text color
          ),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.grey),
          ),
          searchBarTheme: SearchBarThemeData(
            backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
            elevation: MaterialStateProperty.all(0),
            hintStyle: MaterialStateProperty.all(TextStyle(color: Colors.grey[400])),
            textStyle: MaterialStateProperty.all(TextStyle(color: Colors.grey[700])),
          ),
        ),
        home: AuthPage(),
        routes: {
          '/home_page': (context) => const HomePage(),
          '/profile_page': (context) => const ProfilePage(),
        },
      ),
    );
  }
}