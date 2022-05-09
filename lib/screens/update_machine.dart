// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields, prefer_collection_literals

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateArguments {
  final String id;
  final String machineName;
  final String picture;
  final String status;
  final String priority;
  final String equipment;
  final String problem;

  UpdateArguments(this.id, this.machineName, this.picture, this.status,
      this.priority, this.equipment, this.problem);
}

class UpdateMachine extends StatefulWidget {
  static const routeName = '/updatemachine';
  final String id;
  final String machineName;
  final String picture;
  final String status;
  final String priority;
  final String equipment;
  final String problem;
  const UpdateMachine({
    Key? key,
    required this.id,
    required this.machineName,
    required this.picture,
    required this.status,
    required this.priority,
    required this.equipment,
    required this.problem,
  }) : super(key: key);

  @override
  State<UpdateMachine> createState() => _UpdateMachineState();
}

class _UpdateMachineState extends State<UpdateMachine> {
  File? image;
  final formKey = GlobalKey<FormState>();

  TextEditingController id = TextEditingController();
  TextEditingController machineName = TextEditingController();
  TextEditingController equipment = TextEditingController();
  TextEditingController problem = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController picture = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id.text = widget.id;
    machineName.text = widget.machineName;
    equipment.text = widget.equipment;
    problem.text = widget.problem;
    status.text = widget.status;
    priority.text = widget.priority;
    picture.text = widget.picture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Machine'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  image != null
                      ? Image.file(
                          image!,
                          width: 350,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://arthit-vibration-iot.herokuapp.com/uploads/${picture.text}',
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
                    value: status.text,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        status.text = newValue!;
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
                  Text('Problem', style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: problem,
                    validator: RequiredValidator(errorText: 'Enter Problem'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Priority', style: TextStyle(fontSize: 20)),
                  DropdownButton<String>(
                    value: priority.text,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        priority.text = newValue!;
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
                        print(id.text);
                        print(machineName.text);
                        print(status.text);
                        print(equipment.text);
                        print(problem.text);
                        print(priority.text);
                        print(image);

                        if (formKey.currentState!.validate()) {
                          updateMachine().then((value) {
                            formKey.currentState!.reset();
                            const snackBar = SnackBar(
                              content: Text('Update Machine Complete'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/machinelist',
                                (Route<dynamic> route) => false);
                          });
                        }
                      },
                      child: Text('Update Machine',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future updateMachine() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'machine$i.jpg';
    try {
      Map<String, dynamic> map = Map();
      map['machineName'] = machineName.text;
      map['status'] = status.text;
      map['equipment'] = equipment.text;
      map['problem'] = problem.text;
      map['priority'] = priority.text;
      if (image != null) {
        map['file'] =
            await MultipartFile.fromFile(image!.path, filename: nameImage);
      }
      FormData formData = FormData.fromMap(map);
      await Dio()
          .put(
        "https://arthit-vibration-iot.herokuapp.com/api/machine/${id.text}",
        data: formData,
      )
          .then((value) {
        print('response ===> $value');
      });
    } catch (e) {
      print('upload fail:===> $e');
    }
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageSource, maxHeight: 800, maxWidth: 800);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('fail to pick $e');
    }
  }
}
