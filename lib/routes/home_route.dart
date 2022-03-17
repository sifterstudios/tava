import 'package:flutter/material.dart';
import 'package:tava/routes/date_picker.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TAVA',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_none_outlined),
          SizedBox(
            width: 15,
            height: 15,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          DatePickerHorizontal()
        ],
      ),
    );
  }
}
