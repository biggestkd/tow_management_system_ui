import 'package:flutter/material.dart';

class ScheduleTowScreen extends StatefulWidget {
  final String companyUrl;

  const ScheduleTowScreen({
    super.key,
    required this.companyUrl,
  });

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
      body: Center(
        child: Text(
          'Schedule tow for "${widget.companyUrl}"',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
