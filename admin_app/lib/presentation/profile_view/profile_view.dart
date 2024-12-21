import 'package:admin_app/main.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A view that displays user profile information and settings using Material Design 3
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  String _getUserTypeLabel(String type) {
    switch (type) {
      case 'employee':
        return 'Service Provider';
      case 'client':
        return 'Customer';
      default:
        return type.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AuthService>().checkAuthState();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Card
            Card(
              elevation: 0,
              color: colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar with verified badge
                    Stack(
                      children: [
                        Hero(
                          tag: 'profile_avatar',
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: colorScheme.primary,
                            child: CircleAvatar(
                              radius: 58,
                              backgroundColor: colorScheme.surface,
                              child: Icon(
                                Icons.person,
                                size: 64,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        if (user.verified == true)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.verified,
                                size: 24,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      '${user.firstname} ${user.lastname}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      user.email,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            colorScheme.onSecondaryContainer.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User type chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getUserTypeLabel(user.type.name),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Personal Information Section
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: colorScheme.surfaceVariant,
              child: Column(
                children: [
                  _buildInfoTile(
                    context,
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: user.phone ?? 'No phone number',
                  ),
                  if (user.nationalId != null)
                    _buildInfoTile(
                      context,
                      icon: Icons.badge_outlined,
                      title: 'National ID',
                      value: user.nationalId!,
                    ),
                  if (user.placeOfBirth != null)
                    _buildInfoTile(
                      context,
                      icon: Icons.location_city_outlined,
                      title: 'Place of Birth',
                      value: user.placeOfBirth!,
                    ),
                  if (user.dateOfBirth != null)
                    _buildInfoTile(
                      context,
                      icon: Icons.calendar_today_outlined,
                      title: 'Date of Birth',
                      value: user.dateOfBirth!.toString().split(' ')[0],
                    ),
                  _buildInfoTile(
                    context,
                    icon: Icons.person_outline,
                    title: 'Gender',
                    value: user.gender.name.toUpperCase(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Section
            Text(
              'Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: colorScheme.surfaceVariant,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Theme.of(context).brightness == Brightness.light
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Theme Mode',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('Dark'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto),
                          label: Text('System'),
                        ),
                      ],
                      selected: {
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeMode.light
                            : ThemeMode.dark
                      },
                      onSelectionChanged: (Set<ThemeMode> modes) {
                        final mode = modes.first;
                        MainApp.of(context)?.updateThemeMode(mode);
                      },
                    ),
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'App Version',
                    value: '1.0.0',
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: colorScheme.error,
                    ),
                    title: Text(
                      'Logout',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.error,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        await context.read<AuthService>().logoutUser();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
