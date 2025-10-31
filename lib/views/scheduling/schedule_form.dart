import 'package:flutter/material.dart';

class ScheduleTowScreen extends StatefulWidget {
  const ScheduleTowScreen({super.key});

  @override
  State<ScheduleTowScreen> createState() => _ScheduleTowScreenState();
}

class _ScheduleTowScreenState extends State<ScheduleTowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Tow'),
      ),
      body: const Center(
        child: Text('Schedule Tow placeholder'),
      ),
    );
  }
}


