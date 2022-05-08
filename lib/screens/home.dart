// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Machine'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/profile.png',
                width: 350,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: Icon(Icons.login),
                    label: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
