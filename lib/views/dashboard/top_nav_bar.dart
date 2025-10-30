import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/user.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    super.key,
    required this.appName,
    required this.companyName,
    required this.companyActive,
    required this.user,
    required this.onAccountPressed,
    required this.onLogoutPressed,
  });

  final String appName;
  final String companyName;
  final String companyActive;
  final User user;
  final VoidCallback onAccountPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = companyActive == "active" ? 'Active' : 'Inactive';

    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
        child: Row(
          children: [
            // App / Company info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        companyName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: companyActive == "active"
                              ? theme.colorScheme.primary.withOpacity(.1)
                              : theme.colorScheme.error.withOpacity(.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: companyActive == "active"
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // User menu
            PopupMenuButton<String>(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  (user.displayName ?? user.username)!
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'account',
                  child: Text('Account Information'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
              ],
              onSelected: (value) {
                if (value == 'account') onAccountPressed();
                if (value == 'logout') onLogoutPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
