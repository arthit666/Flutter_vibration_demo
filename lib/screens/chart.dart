// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late List<double> listwave;
  late List<double> listspecx;
  late List<double> listspecy;
  late List<WaveData> x;
  late List<SpecData> y = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVibration().then((value) {
      setState(() {
        listspecx = List<double>.from(value['machineEx01']['spectrumX'][1]);
        listspecy = List<double>.from(value['machineEx01']['spectrumX'][0]);
        listwave = List<double>.from(value['machineEx01']['waveformX']);
        x = getDataWave(listwave);
        y = getDataspec(listspecy, listspecx);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytic/Chart'),
      ),
      body: FutureBuilder(
        future: getVibration(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(''),
                  SizedBox(
                    width: double.infinity,
                    child: SfCartesianChart(
                      series: <ChartSeries>[
                        LineSeries<WaveData, double>(
                          dataSource: x,
                          xValueMapper: (WaveData axis, _) => axis.axis,
                          yValueMapper: (WaveData axis, _) => axis.value,
                        )
                      ],
                    ),
                  ),
                  Text('Time Waveform'),
                  Text(''),
                  SizedBox(
                    width: double.infinity,
                    child: SfCartesianChart(
                      series: <ChartSeries>[
                        LineSeries<SpecData, double>(
                            dataSource: y,
                            xValueMapper: (SpecData axis, _) => axis.axis,
                            yValueMapper: (SpecData axis, _) => axis.value,
                            color: Colors.orange)
                      ],
                    ),
                  ),
                  Text('Spectrum'),
                ]),
              ),
            );
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }

  List<WaveData> getDataWave(List<double> list) {
    List<WaveData> waveform = list.asMap().entries.map(
      (e) {
        double index = e.key.toDouble();
        double value = e.value;
        return WaveData(index, value);
      },
    ).toList();
    return waveform;
  }

  List<SpecData> getDataspec(List<double> list1, List<double> list2) {
    List<SpecData> waveform = list1.asMap().entries.map(
      (e) {
        int index = e.key;
        double value = e.value;
        double value2 = list2[index];
        return SpecData(value2, value);
      },
    ).toList();
    return waveform;
  }

  Future<Map> getVibration() async {
    var url = Uri.parse(
        'https://arthit-fastapi-vibration-iot.herokuapp.com/vibration');
    var response = await http.get(url);
    // print('Response body: ${response.body}');
    Map machineList = jsonDecode(response.body);
    return machineList;
  }
}

class WaveData {
  WaveData(this.axis, this.value);
  final double axis;
  final double value;
}

class SpecData {
  SpecData(this.axis, this.value);
  final double axis;
  final double value;
}
