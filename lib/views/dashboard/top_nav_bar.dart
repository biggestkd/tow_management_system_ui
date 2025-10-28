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
  final bool companyActive;
  final User user;
  final VoidCallback onAccountPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = companyActive ? 'Active' : 'Inactive';

    return Material(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
        child: Row(
          children: [
            // App / Company
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appName,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        companyName,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: companyActive
                              ? theme.colorScheme.primary.withOpacity(.1)
                              : theme.colorScheme.error.withOpacity(.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: companyActive
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
                child: Text(
                  (user.displayName ?? user.username)
                      !.substring(0, 1)
                      .toUpperCase(),
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
