// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:vibration_demo/screens/machine_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username', style: TextStyle(fontSize: 20)),
                  TextFormField(
                    validator: RequiredValidator(errorText: 'Enter Username'),
                    controller: username,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Password', style: TextStyle(fontSize: 20)),
                  TextFormField(
                    obscureText: true,
                    validator: RequiredValidator(errorText: 'Enter Pasword'),
                    controller: password,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          loginUser(username.text, password.text).then((value) {
                            print('Value $value');
                            print(value['payload']['user']);
                            if (value.isNotEmpty) {
                              formKey.currentState!.reset();
                              const snackBar = SnackBar(
                                content: Text('Login Complete'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pushReplacementNamed(
                                context,
                                '/machinelist',
                              );
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Login Fail'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          });
                        }
                      },
                      child: Text('Login', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<Map> loginUser(username, password) async {
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata = '{"username":"$username","password":"$password"}';
    var url = Uri.parse('https://arthit-vibration-iot.herokuapp.com/api/login');
    var response = await http.post(url, headers: header, body: jsondata);
    // print('Response status: ${response.statusCode}');
    // print('Response body: $response');
    Map<String, dynamic> user = jsonDecode(response.body);
    return user;
  }
}
