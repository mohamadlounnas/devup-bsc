import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import '../../utils/responsive.dart';

/// Screen that displays user profile information and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    final isDesktop = Responsive.isDesktop(context);

    if (user == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Profile'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.square_arrow_right),
          onPressed: () async {
            final confirmed = await showCupertinoDialog<bool>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await context.read<AuthService>().logout();
            }
          },
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await context.read<AuthService>().checkAuthState();
            },
          ),
          // Add padding at the top to account for navigation bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          // Profile Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Hero(
                      tag: 'profile_avatar',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.systemBlue.resolveFrom(context),
                              CupertinoColors.activeBlue.resolveFrom(context),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.person_fill,
                          size: 60,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${user.firstname} ${user.lastname}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getUserTypeLabel(user.type.name),
                        style: TextStyle(
                          color: CupertinoColors.systemBlue.resolveFrom(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Personal Information Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
              child: const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: CupertinoIcons.phone,
                    title: 'Phone',
                    value: user.phone ?? 'No phone number',
                  ),
                  if (user.nationalId != null)
                    _buildInfoTile(
                      icon: CupertinoIcons.creditcard,
                      title: 'National ID',
                      value: user.nationalId!,
                    ),
                  if (user.placeOfBirth != null)
                    _buildInfoTile(
                      icon: CupertinoIcons.location_solid,
                      title: 'Place of Birth',
                      value: user.placeOfBirth!,
                    ),
                  if (user.dateOfBirth != null)
                    _buildInfoTile(
                      icon: CupertinoIcons.calendar,
                      title: 'Date of Birth',
                      value: user.dateOfBirth!.toString().split(' ')[0],
                    ),
                  _buildInfoTile(
                    icon: CupertinoIcons.person,
                    title: 'Gender',
                    value: user.gender.name.toUpperCase(),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Settings Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
              child: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Consumer<ThemeService>(
                    builder: (context, themeService, _) {
                      return CupertinoFormRow(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        prefix: Row(
                          children: [
                            Icon(
                              themeService.isDarkMode
                                  ? CupertinoIcons.moon_fill
                                  : CupertinoIcons.sun_max_fill,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 12),
                            const Text('Dark Mode'),
                          ],
                        ),
                        child: CupertinoSwitch(
                          value: themeService.isDarkMode,
                          onChanged: (_) => themeService.toggleTheme(),
                        ),
                      );
                    },
                  ),
                  _buildInfoTile(
                    icon: CupertinoIcons.info,
                    title: 'App Version',
                    value: '1.0.0',
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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