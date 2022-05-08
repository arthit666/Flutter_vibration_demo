// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_print, unnecessary_string_interpolations, empty_catches, prefer_collection_literals

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class CreateMachine extends StatefulWidget {
  CreateMachine({Key? key}) : super(key: key);

  @override
  State<CreateMachine> createState() => _CreateMachineState();
}

class _CreateMachineState extends State<CreateMachine> {
  String status = 'Running';
  String priority = '4';
  File? image;
  final formKey = GlobalKey<FormState>();
  TextEditingController machineName = TextEditingController();
  TextEditingController equipment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Machine'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ignore: prefer_const_constructors
                  image != null
                      ? Image.file(
                          image!,
                          width: 350,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/defaultmachineimage.jpg',
                          width: 350,
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.blue,
                          iconSize: 40,
                          onPressed: () {
                            pickImage(ImageSource.camera);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_photo_alternate),
                          color: Colors.blue,
                          iconSize: 40,
                          onPressed: () {
                            pickImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ),
                  Text('Machine Name', style: TextStyle(fontSize: 20)),
                  TextFormField(
                    validator: RequiredValidator(errorText: 'Machine Name'),
                    controller: machineName,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Status', style: TextStyle(fontSize: 20)),

                  DropdownButton<String>(
                    value: status,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        status = newValue!;
                      });
                    },
                    items: <String>['Running', 'Stop', 'Maintenance']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 17),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Equipment', style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: equipment,
                    validator: RequiredValidator(errorText: 'Enter Equipment'),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Text('Priority', style: TextStyle(fontSize: 20)),

                  DropdownButton<String>(
                    value: priority,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        priority = newValue!;
                      });
                    },
                    items: <String>['4', '3', '2', '1']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 17),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print(status);
                        print(priority);

                        if (formKey.currentState!.validate()) {
                          createMachine().then((value) {
                            formKey.currentState!.reset();
                            const snackBar = SnackBar(
                              content: Text('Create Machine Complete'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pushReplacementNamed(
                                context, '/machinelist');
                          });
                        }
                      },
                      child: Text('Create Machine',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future createMachine() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'machine$i.jpg';
    try {
      Map<String, dynamic> map = Map();
      map['machineName'] = machineName.text;
      map['status'] = status;
      map['equipment'] = equipment.text;
      map['priority'] = priority;
      if (image != null) {
        map['file'] =
            await MultipartFile.fromFile(image!.path, filename: nameImage);
      }
      FormData formData = FormData.fromMap(map);
      await Dio()
          .post(
        "https://arthit-vibration-iot.herokuapp.com/api/machine/create",
        data: formData,
      )
          .then((value) {
        print('response ===> $value');
      });
    } catch (e) {
      print('upload fail');
    }
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      // print(image);

      final imageTemporary = File(image.path);
      // print(imageTemporary);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('fail to pick $e');
    }
  }
}
