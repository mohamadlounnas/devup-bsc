import 'package:admin_app/main.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A view that displays user profile information and settings using Material Design 3
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _tourKey1 = GlobalKey();
  final _tourKey2 = GlobalKey();
  final _tourKey3 = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => TutorialDialog(
        steps: [
          TutorialStep(
            title: 'Profile Information',
            content: 'View and manage your personal information here.',
            targetKey: _tourKey1,
          ),
          TutorialStep(
            title: 'Personal Details',
            content:
                'Your contact and identification details are displayed here.',
            targetKey: _tourKey2,
          ),
          TutorialStep(
            title: 'Settings & Actions',
            content: 'Customize app settings and manage your account.',
            targetKey: _tourKey3,
          ),
        ],
      ),
    );
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Card
            Card(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Avatar with verified badge
                    Stack(
                      children: [
                        Hero(
                          tag: 'profile_avatar',
                          child: CircleAvatar(
                            radius: 64,
                            backgroundColor: colorScheme.primary,
                            child: CircleAvatar(
                              radius: 62,
                              backgroundColor: colorScheme.surface,
                              child: Icon(
                                Icons.person,
                                size: 72,
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
                                size: 28,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Name
                    Text(
                      '${user.firstname} ${user.lastname}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email
                    Text(
                      user.email,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            colorScheme.onSecondaryContainer.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // User type chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(24),
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
            const SizedBox(height: 32),

            // Personal Information Section
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
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
            const SizedBox(height: 32),

            // Settings Section
            Text(
              'Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Theme Mode',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        SegmentedButton<ThemeMode>(
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
                      ],
                    ),
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'App Version',
                    value: '1.0.0',
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: colorScheme.error,
                      size: 28,
                    ),
                    title: Text(
                      'Logout',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Sign out of your account',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error.withOpacity(0.8),
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
            const SizedBox(height: 32),
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
        horizontal: 24,
        vertical: 16,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 20),
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

class TutorialStep {
  final String title;
  final String content;
  final GlobalKey targetKey;

  TutorialStep({
    required this.title,
    required this.content,
    required this.targetKey,
  });
}

class TutorialDialog extends StatefulWidget {
  final List<TutorialStep> steps;

  const TutorialDialog({
    required this.steps,
    super.key,
  });

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final step = widget.steps[currentStep];

    return AlertDialog(
      title: Text(step.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(step.content),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (currentStep + 1) / widget.steps.length,
            backgroundColor: colorScheme.surfaceVariant,
            color: colorScheme.primary,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
        FilledButton(
          onPressed: () {
            if (currentStep < widget.steps.length - 1) {
              setState(() {
                currentStep++;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(
            currentStep < widget.steps.length - 1 ? 'Next' : 'Done',
          ),
        ),
      ],
    );
  }
}
