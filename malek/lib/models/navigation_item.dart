import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

const List<NavigationItem> navigationItems = [
  NavigationItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  NavigationItem(
    label: 'Services',
    icon: Icons.miscellaneous_services_outlined,
    selectedIcon: Icons.miscellaneous_services_rounded,
  ),
]; 