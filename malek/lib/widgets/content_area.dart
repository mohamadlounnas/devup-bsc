import 'package:flutter/material.dart';
import '../models/navigation_item.dart';
import '../pages/services_page.dart';

class ContentArea extends StatelessWidget {
  final int selectedIndex;

  const ContentArea({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              navigationItems[selectedIndex].label,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: selectedIndex == 1
                  ? const ServicesTable()
                  : Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(32),
                      child: const Center(
                        child: Text('Home Content'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 