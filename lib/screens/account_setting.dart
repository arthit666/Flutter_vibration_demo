import 'package:flutter/material.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({Key? key}) : super(key: key);

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Setting'),
      ),
    );
  }
}
