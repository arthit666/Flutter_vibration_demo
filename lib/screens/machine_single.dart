// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MachineSingleArguments {
  final String id;
  final String machineName;
  final String picture;
  final String status;
  final String priority;
  final String equipment;
  final String problem;

  MachineSingleArguments(this.id, this.machineName, this.picture, this.status,
      this.priority, this.equipment, this.problem);
}

class MachineSingle extends StatefulWidget {
  MachineSingle({Key? key}) : super(key: key);

  @override
  State<MachineSingle> createState() => _MachineSingleState();
}

class _MachineSingleState extends State<MachineSingle> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MachineSingleArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.machineName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://arthit-vibration-iot.herokuapp.com/uploads/${args.picture}')),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: tableMachineDetail(args.machineName, args.equipment,
                  args.status, args.problem, args.priority),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/analytics');
                    },
                    child: Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      print(args.id);
                      deleteMachine(args.id).then((value) {
                        const snackBar = SnackBar(
                          content: Text('Delete Machine Complete'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacementNamed(context, '/machinelist');
                      });
                    },
                    child: Text(
                      'Delete Machine',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tableMachineDetail(name, equi, status, prob, pri) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Result',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Machine Name',
              style: TextStyle(
                fontSize: 16,
              ),
            )),
            DataCell(Text(
              name,
              style: TextStyle(
                fontSize: 16,
              ),
            )),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Equipment',
              style: TextStyle(fontSize: 16),
            )),
            DataCell(Text(
              equi,
              style: TextStyle(fontSize: 16),
            )),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Status',
              style: TextStyle(fontSize: 16),
            )),
            DataCell(checkStatus(status)),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Problem',
              style: TextStyle(fontSize: 16),
            )),
            DataCell(Text(
              prob,
              style: TextStyle(fontSize: 16),
            )),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Priority',
              style: TextStyle(fontSize: 16),
            )),
            DataCell(checkPrioruty(pri)),
          ],
        ),
      ],
    );
  }

  Future deleteMachine(id) async {
    try {
      await Dio()
          .delete('https://arthit-vibration-iot.herokuapp.com/api/machine/$id')
          .then((value) {
        print('response ===> $value');
      });
    } catch (e) {
      print('upload fail');
    }
  }

  Widget checkPrioruty(status) {
    if (status == "4") {
      return FaIcon(
        FontAwesomeIcons.faceSmile,
        color: Colors.green,
      );
    } else if (status == "3") {
      return FaIcon(
        FontAwesomeIcons.faceMeh,
        color: Colors.yellow,
      );
    } else if (status == "2") {
      return FaIcon(
        FontAwesomeIcons.faceFrownOpen,
        color: Colors.orange,
      );
    } else {
      return FaIcon(FontAwesomeIcons.faceFrown, color: Colors.red);
    }
  }

  Widget checkStatus(status) {
    if (status == "Running") {
      return FaIcon(
        FontAwesomeIcons.circlePlay,
        color: Colors.green,
      );
    } else if (status == "Stop") {
      return FaIcon(
        FontAwesomeIcons.circleStop,
        color: Colors.red,
      );
    } else {
      return FaIcon(FontAwesomeIcons.screwdriverWrench, color: Colors.grey);
    }
  }
}
