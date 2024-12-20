import 'package:flutter/material.dart';
import 'package:shared/models/hostel.dart';

/// Card widget to display hostel information
class HostelCard extends StatelessWidget {
  final Hostel? hostel;

  const HostelCard({super.key, this.hostel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8.0),
        child: hostel == null 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hostel!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(hostel!.address ?? '<No address>'),
                Text('Status: ${hostel!.address}'),
              ],
            ),
      ),
    );
  }
} 