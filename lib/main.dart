import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(PlantWateringApp());
}

class PlantWateringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Mate',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 29, 23, 183), // Set the primary color
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.yellow,
        ).copyWith(
          primary: Color.fromARGB(255, 181, 251, 90), // Primary color
          secondary: Color(0xFF025943), // Accent/secondary color
        ),
        scaffoldBackgroundColor: Colors.white, // Set background color
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF028960), // AppBar color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: 'Outfit',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF028960), // Button background color
          ),
        ),
        fontFamily: 'Outfit', // Set default font family
        // textTheme: ThemeData.light().textTheme.apply(
        //       fontFamily: 'Outfit', // Apply to text theme
        //     ),
      ),
      home: SplashScreen(),
    );
  }
}
