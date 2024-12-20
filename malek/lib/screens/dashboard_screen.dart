import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/content_area.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void onNavigationItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: onNavigationItemSelected,
          ),
          ContentArea(selectedIndex: _selectedIndex),
        ],
      ),
    );
  }
} 