// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

import 'package:form_field_validator/form_field_validator.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController company = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                  Text('Email', style: TextStyle(fontSize: 20)),
                  TextFormField(
                      controller: email,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Enter Username'),
                        EmailValidator(errorText: 'Email invalid')
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Company', style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: company,
                    validator: RequiredValidator(errorText: 'Enter Company'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          registerUser().then((value) {
                            print('Value $value');
                            if (value == 200) {
                              formKey.currentState!.reset();
                              const snackBar = SnackBar(
                                content: Text('Register Complete'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Register Faill'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          });
                        }
                      },
                      child: Text('Register', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<int> registerUser() async {
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata =
        '{"username":"${username.text}","password":"${password.text}","email":"${email.text}","company":"${company.text}"}';
    var url =
        Uri.parse('https://arthit-vibration-iot.herokuapp.com/api/register');
    var response = await http.post(url, headers: header, body: jsondata);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    return response.statusCode;
  }
}
