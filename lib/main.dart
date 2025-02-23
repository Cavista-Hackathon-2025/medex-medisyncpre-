import 'dart:io';

import 'package:flutter/material.dart';

import 'view/main_tabview/main_tabview.dart';
import 'view/medication/medication_view.dart';
import 'view/on_boarding/startup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


SharedPreferences? prefs;
void main() async {


  runApp( const MyApp(defaultHome:  StartupView(),));
}



class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediSyncpatient',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
         home: const MainTabView(),

    );
  }
}
