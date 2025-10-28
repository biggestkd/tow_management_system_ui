// lib/screens/onboarding/onboarding_screen.dart
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/colors.dart';
import 'package:tow_management_system_ui/models/user.dart';
import 'package:tow_management_system_ui/views/dashboard/scheduling_link_section.dart';
import 'package:tow_management_system_ui/views/dashboard/top_nav_bar.dart';
import 'package:tow_management_system_ui/views/dashboard/tow_section.dart';

import '../../models/company.dart';
import '../../models/tow.dart';
import 'metrics_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  User? _user;
  Company? _company;
  int _activeCount = 0;
  int _completedToday = 0;
  double _totalRevenue = 0;
  final List<Tow> _activeTows = const [];
  final List<Tow> _towHistory = [
    Tow(
      id: 'tow_001',
      destination: "Mike's Auto Repair, 5678 Oak Avenue, Riverside, CA 92501",
      pickup: '1234 Main Street, Downtown, CA 90210',
      vehicle: '2019 Honda Accord',
      primaryContact: 'Sarah Johnson',
      attachments: const [],
      notes: "Vehicle won't start. Battery appears dead.",
      history: const ['Created', 'Driver Assigned'],
      status: 'Active',
      checkoutUrl: 'https://withtowpro.com/checkout/tow_001',
      createdAt: DateTime(2025, 10, 13, 11, 18),
      price: 125.00,
    ),
    Tow(
      id: 'tow_001',
      destination: "Mike's Auto Repair, 5678 Oak Avenue, Riverside, CA 92501",
      pickup: '1234 Main Street, Downtown, CA 90210',
      vehicle: '2019 Honda Accord',
      primaryContact: 'Sarah Johnson',
      attachments: const [],
      notes: "Vehicle won't start. Battery appears dead.",
      history: const ['Created', 'Driver Assigned'],
      status: 'Completed',
      checkoutUrl: 'https://withtowpro.com/checkout/tow_001',
      createdAt: DateTime(2025, 10, 13, 11, 18),
      price: 125.00,
    ),
  ];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {

      // TODO: update these value from the controller

      final user = User(
        id: 'uid_123',
        username: 'kdowdy',
        displayName: 'Kevin Dowdy',
        avatarUrl: null,
      );

      // Company for this user
      final company = Company(
        id: 'cmp_1',
        name: 'Kommunity Works LLC',
        active: false, // matches "Inactive" in your mock
        schedulingLink: 'kommunity-works-llc',
      );

      // Metrics (example placeholders)
      final activeCount = 0;
      final completedToday = 0;
      final totalRevenue = 0.0;

      // Tows
      final activeTows = <Tow>[];
      final towHistory = <Tow>[];

      setState(() {
        _user = user;
        _company = company;
        _activeCount = activeCount;
        _completedToday = completedToday;
        _totalRevenue = totalRevenue;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load dashboard';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: _loading ? const Center(child: CircularProgressIndicator()) : _error != null ? Center(child: Text(_error!))
            : RefreshIndicator(
          onRefresh: _bootstrap,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: TopNavBar(
                  appName: 'Tow Pro',
                  companyName: _company?.name ?? '',
                  companyActive: _company?.active ?? false,
                  user: _user!,
                  onAccountPressed: () {
                    // TODO: go_router to /account
                  },
                  onLogoutPressed: () async {
                    // TODO: Amplify.Auth.signOut(); then context.go('/login')
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SchedulingLinkSection(
                    company: _company!,
                    onCopyPressed: (link) async {
                      // Clipboard.setData(ClipboardData(text: link));
                      // Optional: showSnackBar
                    },
                    onVisitPressed: (link) {
                      // TODO: launchUrlString(link)
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: MetricsSection(
                    activeCount: _activeCount,
                    completedToday: _completedToday,
                    totalRevenue: _totalRevenue,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TowsSection(
                    company: _company!,
                    activeTows: _activeTows,
                    towHistory: _towHistory,
                    onOpenSchedule: () {
                      final link = _company!.schedulingLink;
                      if (link != null) {
                        // TODO: launchUrlString(link)
                      }
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
