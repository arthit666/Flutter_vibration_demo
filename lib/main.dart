// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vibration_demo/screens/account_setting.dart';
import 'package:vibration_demo/screens/analytics.dart';
import 'package:vibration_demo/screens/chart.dart';
import 'package:vibration_demo/screens/create_machine.dart';
import 'package:vibration_demo/screens/home.dart';
import 'package:vibration_demo/screens/login.dart';
import 'package:vibration_demo/screens/machine_list.dart';
import 'package:vibration_demo/screens/machine_single.dart';
import 'package:vibration_demo/screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/machinelist': (context) => MachineList(),
        '/machinesingle': (context) => MachineSingle(),
        '/createmachine': (context) => CreateMachine(),
        '/accountsetting': (context) => AccountSetting(),
        '/analytics': (context) => Analytics(),
        '/chart': (context) => ChartScreen(),
      },
    );
  }
}
