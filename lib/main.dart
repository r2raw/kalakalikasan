import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/screens/login.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
var darkGreenScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 32, 77, 44));
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: darkGreenScheme,
          hintColor: Color.fromARGB(132, 38, 167, 72),
          primaryColor: Color.fromARGB(255, 32, 77, 44),
          textTheme: TextTheme(
              headlineLarge: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                    255, 32, 77, 44), 
              ),
              headlineMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                    255, 32, 77, 44), 
              ),
              headlineSmall: TextStyle(
                fontSize: 11,
                color: Color.fromARGB(
                    255, 32, 77, 44),
              )),
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: Color.fromARGB(132, 38, 167, 72)),
          inputDecorationTheme: InputDecorationTheme(
            focusColor: Color.fromARGB(255, 32, 77, 44),
            fillColor: Color.fromARGB(255, 32, 77, 44),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 38, 167, 72),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 38, 167, 72),
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 38, 167, 72),
              ),
            ),
          ),
          cardTheme: CardTheme(
            
            color: Color.fromARGB(
                255, 245, 245, 245), 
            // color: Color.fromARGB(
            //     255, 235, 245, 235), // Light background for contrast
            shadowColor:
                Color.fromARGB(80, 32, 77, 44), // Subtle dark green shadow
            elevation: 3, // Lower elevation to reduce harsh shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
        ),
        home: Login(),
        navigatorObservers: [routeObserver],
      ),
    ),
  );
}
