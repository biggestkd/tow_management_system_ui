// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tow_management_system_ui/colors.dart';
import 'package:tow_management_system_ui/views/onboarding/step_confirmation.dart';

import '../../models/account.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          const double cardSide = 520;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 0),
              child: Center(
                child:Text("Dashboard")
              ),
            ),
          );
        },
      ),
    );
  }
}

