// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/user.dart';
import 'package:tow_management_system_ui/views/dashboard/scheduling_link_section.dart';
import 'package:tow_management_system_ui/views/dashboard/top_nav_bar.dart';
import 'package:tow_management_system_ui/views/dashboard/tow_section.dart';

import '../../controllers/dashboard_controller.dart';
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
  List<Tow> _towHistory = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final user = await DashboardController.loadUser();

      // Load company referenced by user
      final company = await DashboardController.loadCompany(user?.companyId);

      // Load metrics (list)
      final metrics = await DashboardController.loadMetrics(user?.companyId);

      final String? vActive   = (metrics != null && metrics.isNotEmpty) ? metrics[0].value : null;
      final String? vCompleted= (metrics != null && metrics.length > 1) ? metrics[1].value : null;
      final String? vRevenue  = (metrics != null && metrics.length > 2) ? metrics[2].value : null;

      final int activeCount      = int.tryParse(vActive ?? '') ?? 0;
      final int completedToday   = int.tryParse(vCompleted ?? '') ?? 0;
      final double totalRevenue  = double.tryParse(vRevenue ?? '') ?? 0.0;

      // Load tow history
      final towHistory = await DashboardController.loadTowHistory(user?.companyId);

      setState(() {
        _user = user;
        _company = company;
        _activeCount = activeCount;
        _completedToday = completedToday;
        _totalRevenue = totalRevenue;
        _towHistory = towHistory!;
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
                  companyActive: _company?.status ?? '',
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
