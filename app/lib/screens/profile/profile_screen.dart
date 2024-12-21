import 'dart:ui';

import 'package:app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import '../../utils/responsive.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Screen that displays user profile information and settings using Material Design 3
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    final isDesktop = Responsive.isDesktop(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface.withOpacity(0.7),
      extendBodyBehindAppBar: true,

      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<AuthService>().checkAuthState();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : 16,
            vertical: 24 + MediaQuery.of(context).padding.top,
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomNavbar(),
                  const SizedBox(height: 16),
                  // Profile Header Card
                  Card(
                    elevation: 0,
                    color: colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Avatar with verified badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Hero(
                                    tag: 'profile_avatar',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorScheme.primary.withOpacity(0.2),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: colorScheme.primary,
                                        child: CircleAvatar(
                                          radius: 58,
                                          backgroundColor: colorScheme.surface,
                                          child: Icon(
                                            Iconsax.user,
                                            size: 48,
                                            color: colorScheme.primary,
                                          ),
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
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorScheme.shadow.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Iconsax.verify5,
                                          size: 24,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // qr code button
GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Your Check-in Code',
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: colorScheme.shadow.withOpacity(0.1),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: QrImageView(
                                            data: 'user:${user.id}',
                                            version: QrVersions.auto,
                                            size: 300,
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'Scan this code at events for quick check-in',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.qr_code_2, size: 50),
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
                              color: colorScheme.onSecondaryContainer.withOpacity(0.8),
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
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.user_tick,
                                  size: 16,
                                  color: colorScheme.onTertiaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getUserTypeLabel(user.type.name),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Personal Information Section
                  _buildSectionHeader(
                    context,
                    title: 'Personal Information',
                    icon: Iconsax.user_edit,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceVariant,
                    child: Column(
                      children: [
                        _buildInfoTile(
                          context,
                          icon: Iconsax.call,
                          title: 'Phone',
                          value: user.phone ?? 'No phone number',
                        ),
                        if (user.nationalId != null)
                          _buildInfoTile(
                            context,
                            icon: Iconsax.card,
                            title: 'National ID',
                            value: user.nationalId!,
                          ),
                        if (user.placeOfBirth != null)
                          _buildInfoTile(
                            context,
                            icon: Iconsax.building,
                            title: 'Place of Birth',
                            value: user.placeOfBirth!,
                          ),
                        if (user.dateOfBirth != null)
                          _buildInfoTile(
                            context,
                            icon: Iconsax.calendar_1,
                            title: 'Date of Birth',
                            value: user.dateOfBirth!.toString().split(' ')[0],
                          ),
                        _buildInfoTile(
                          context,
                          icon: Iconsax.user,
                          title: 'Gender',
                          value: user.gender.name.toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Section
                  _buildSectionHeader(
                    context,
                    title: 'Settings',
                    icon: Iconsax.setting_2,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceVariant,
                    child: Column(
                      children: [
                        Consumer<ThemeService>(
                          builder: (context, themeService, _) {
                            return SwitchListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    themeService.isDarkMode
                                        ? Iconsax.moon
                                        : Iconsax.sun_1,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Dark Mode',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              value: themeService.isDarkMode,
                              onChanged: (_) => themeService.toggleTheme(),
                            );
                          },
                        ),
                        _buildInfoTile(
                          context,
                          icon: Iconsax.info_circle,
                          title: 'App Version',
                          value: '1.0.0',
                        ),
                        // logout list tile
                        ListTile(
                          leading: const Icon(Iconsax.logout),
                          title: const Text('Logout'),
                          onTap: () {
                            context.read<AuthService>().logout();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQRActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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

/// A custom navigation bar with blur effect
class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          ),
          Image.asset(
            'assets/logo/icon.png',
            height: 28,
            semanticLabel: 'App logo',
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }
} 