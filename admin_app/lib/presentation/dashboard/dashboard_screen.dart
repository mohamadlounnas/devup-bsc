import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = true;
  int selectedIndex = 0;

  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    MenuItem(icon: Icons.people_outline, label: 'Users'),
    MenuItem(icon: Icons.analytics_outlined, label: 'Analytics'),
    MenuItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.menu_open : Icons.menu,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  menuItems[selectedIndex].label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                // Theme Toggle
                IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.light
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  onPressed: () {
                    final platform = Theme.of(context).platform;
                    if (platform == TargetPlatform.iOS ||
                        platform == TargetPlatform.android) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please use system settings'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      final brightness = Theme.of(context).brightness;
                      final themeMode = brightness == Brightness.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                      MainApp.of(context)?.updateThemeMode(themeMode);
                    });
                  },
                ),
                const SizedBox(width: 8),
                // User Avatar with Popup Menu
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  child: const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person_outline, size: 20),
                  ),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    if (value == 'logout') {
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Side Menu
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isExpanded ? 250 : 70,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 2,
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedIndex == index
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.transparent,
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: ListTile(
                            leading: Icon(
                              menuItems[index].icon,
                              color: selectedIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            title: isExpanded
                                ? Text(menuItems[index].label)
                                : null,
                            selected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),
                // Content Area
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Text(
                        'Content for ${menuItems[selectedIndex].label}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
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

class MenuItem {
  final IconData icon;
  final String label;

  MenuItem({required this.icon, required this.label});
}
