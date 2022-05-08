// ignore_for_file: prefer_const_constructors_in_immutables, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:vibration_demo/screens/machine_single.dart';

class MachineList extends StatefulWidget {
  MachineList({Key? key}) : super(key: key);

  @override
  State<MachineList> createState() => _MachineListState();
}

class _MachineListState extends State<MachineList> {
  var machineList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine List'),
      ),
      body: FutureBuilder(
        future: getMachine(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getBody(snapshot.data);
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
      drawer: getDrawer(context, 'Arthit'),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/createmachine');
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)),
    );
  }

  Drawer getDrawer(BuildContext context, name) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        UserAccountsDrawerHeader(
          accountName: Text(name),
          accountEmail: Text('example@mail.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://scontent.furt2-1.fna.fbcdn.net/v/t1.6435-9/90085035_3030316437019340_8966418686294360064_n.jpg?_nc_cat=109&ccb=1-6&_nc_sid=09cbfe&_nc_eui2=AeEMVlIPEbI5qjbepUVgSvik0ao2drfB4QrRqjZ2t8HhCr-VJehpPJBMxSafK5CseeqLvqi2Rbp5xT_qTUmlI0na&_nc_ohc=9fUry9PuLh4AX8Nv23y&_nc_ht=scontent.furt2-1.fna&oh=00_AT81Q2tWzek0qxcAT0MctSmrLa2TEDjrgWVjx8CaYViHkg&oe=629DDB01'),
          ),
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.rectangleList,
          ),
          title: const Text('Machine List'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/machinelist');
          },
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.user,
          ),
          title: const Text('Account Setting'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/accountsetting');
          },
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.rightFromBracket,
          ),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ]),
    );
  }

  Future<List> getMachine() async {
    var url =
        Uri.parse('https://arthit-vibration-iot.herokuapp.com/api/machine');
    var response = await http.get(url);
    print('Response body: ${response.body}');
    machineList = jsonDecode(response.body);
    List reversedList = new List.from(machineList.reversed);
    return reversedList;
  }

  Widget getBody(machinelist) {
    return ListView.builder(
      itemCount: machinelist.length,
      itemBuilder: (context, index) {
        return getCard(machinelist[index]);
      },
    );
  }

  Widget getCard(item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/machinesingle',
                arguments: MachineSingleArguments(
                  item['_id'],
                  item['machineName'],
                  item['machinePic'],
                  item['status'],
                  item['priority'],
                  item['equipment'],
                  item['problem'],
                ));
          },
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://arthit-vibration-iot.herokuapp.com/uploads/${item['machinePic']}')),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item['machineName']}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(child: checkStatus(item['status'])),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        '${item['status']}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 133, 131, 131),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      SizedBox(child: checkPrioruty(item['priority'])),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Priority ${item['priority']}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 133, 131, 131),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
