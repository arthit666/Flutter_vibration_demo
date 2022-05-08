// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'dart:math';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytic/Vibration Value'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: tableVibration('Acceleration (mm/s^2)'),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          SizedBox(
            width: double.infinity,
            child: tableVibration('Velocity (mm/s)'),
          ),
          SizedBox(
            width: double.infinity,
            child: tableVibration('Displacement (mm)'),
          ),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chart');
                  },
                  child: Text(
                    'Chart',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
            ),
          )
        ]),
      ),
    );
  }

  Widget tableVibration(name) {
    return DataTable(
      columnSpacing: 0,
      horizontalMargin: 0,
      columns: <DataColumn>[
        DataColumn(
          label: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Center(
              child: Text(
                'Axis',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        DataColumn(
          label: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Center(
              child: Text(
                'X-axis',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                (random.nextDouble() * 5).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Center(
              child: Text(
                'Y-axis',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                (random.nextDouble() * 5).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Center(
              child: Text(
                'Z-axis',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                (random.nextDouble() * 5).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }
}
