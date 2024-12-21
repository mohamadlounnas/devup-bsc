import 'dart:ui';
import 'package:app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cached_tile_provider/flutter_map_cached_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared/shared.dart';

/// Screen that shows facilities and hostels on a map
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen map
        FlutterMap(
          options: MapOptions(
            // center on Boumerdes (wilaya of algeria)
            center: const LatLng(36.7525, 3.0420),
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
              tileProvider: CachedTileProvider(),
            ),
            // Draw Boumerdes borders using polygon
            PolygonLayer(
              polygons: [
                Polygon(
                  points: const [
                    // Northern Mediterranean coastline (detailed)
                    LatLng(36.9072, 3.4821),
                    LatLng(36.8957, 3.4612),
                    LatLng(36.8892, 3.4323),
                    LatLng(36.8798, 3.3956),
                    LatLng(36.8721, 3.3612),
                    LatLng(36.8634, 3.3289),
                    LatLng(36.8532, 3.2978),
                    LatLng(36.8423, 3.2789),
                    // Cap Djinet peninsula
                    LatLng(36.8389, 3.2534),
                    LatLng(36.8312, 3.2412),
                    LatLng(36.8245, 3.2367),
                    // Western border with Algiers
                    LatLng(36.7989, 3.2289),
                    LatLng(36.7823, 3.2245),
                    LatLng(36.7634, 3.2223),
                    LatLng(36.7412, 3.2256),
                    // Khemis El Khechna area
                    LatLng(36.7234, 3.2312),
                    LatLng(36.7089, 3.2445),
                    LatLng(36.6923, 3.2578),
                    // Southern mountainous region
                    LatLng(36.6745, 3.2789),
                    LatLng(36.6589, 3.3023),
                    LatLng(36.6478, 3.3245),
                    LatLng(36.6389, 3.3489),
                    // Dellys region and coastline
                    LatLng(36.6423, 3.3723),
                    LatLng(36.6512, 3.3956),
                    LatLng(36.6634, 3.4189),
                    LatLng(36.6789, 3.4378),
                    // Eastern border with Tizi Ouzou
                    LatLng(36.6923, 3.4523),
                    LatLng(36.7089, 3.4645),
                    LatLng(36.7234, 3.4734),
                    LatLng(36.7412, 3.4812),
                    LatLng(36.7634, 3.4867),
                    LatLng(36.7823, 3.4889),
                    // Zemmouri El Bahri coastal area
                    LatLng(36.7989, 3.4912),
                    LatLng(36.8156, 3.4889),
                    LatLng(36.8323, 3.4867),
                    LatLng(36.8489, 3.4845),
                    LatLng(36.8634, 3.4823),
                    LatLng(36.8789, 3.4845),
                    LatLng(36.8923, 3.4834),
                    LatLng(36.9072, 3.4821), // Close the polygon
                  ],
                  color: Colors.blue.withOpacity(0.15),
                  borderColor: Colors.blue.shade800,
                  borderStrokeWidth: 2.0,
                  isDotted: true,
                  label: 'Wilaya de Boumerdes',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Floating navigation bar with blur effect
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          right: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: CustomNavbar(),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      //   borderRadius: BorderRadius.circular(30),
      //   border: Border.all(
      //     color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // TODO: Implement location centering
            },
            tooltip: 'Center on my location',
          ),
          Image.asset(
            'assets/logo/icon.png',
            height: 28,
            semanticLabel: 'App logo',
          ),
          ThemeToggle(),
        ],
      ),
    );
  }
}
