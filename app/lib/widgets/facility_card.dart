import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Card widget to display facility information
class FacilityCard extends StatelessWidget {
  final Facility? facility;

  const FacilityCard({super.key, this.facility});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8.0),
        child: facility == null 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (facility!.description != null)
                  Text(
                    facility!.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
      ),
    );
  }
} 