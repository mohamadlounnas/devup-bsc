import 'dart:ui';
import 'package:app/widgets/theme_toggle.dart';
import 'package:app/widgets/travel_assistant_chat.dart';
import 'package:app/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cached_tile_provider/flutter_map_cached_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared/shared.dart';
import 'package:app/providers/events_provider.dart';
import 'package:app/providers/hostels_provider.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

/// Screen that shows facilities and hostels on a map
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showChat = false;
  late final GeminiService _geminiService;
  late final EventsProvider _eventsProvider;
  late final HostelsProvider _hostelsProvider;
  final _popupLayerController = PopupController();

  // Filter states
  bool _showEvents = true;
  bool _showHostels = true;
  bool _showFacilities = true;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with your Gemini API key
    _geminiService =
        GeminiService(apiKey: 'AIzaSyBFaNgOZlD--RtxezGxoLDPSaXEo8PcEX8');
    _eventsProvider = EventsProvider();
    _hostelsProvider = HostelsProvider();

    // Load data
    _eventsProvider.subscribeToEvents();
    _hostelsProvider.loadHostels();
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _hostelsProvider.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  List<Marker> _buildEventMarkers() {
    return _eventsProvider.events.where((event) {
      return event.latitude != null && event.longitude != null;
    }).map((event) {
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(event.latitude!, event.longitude!),
        builder: (context) => _buildMarkerIcon(
          Icons.event,
          Theme.of(context).colorScheme.primary,
          event.name,
        ),
      );
    }).toList();
  }

  List<Marker> _buildHostelMarkers() {
    return _hostelsProvider.hostels.where((hostel) {
      return hostel.latitude != null && hostel.longitude != null;
    }).map((hostel) {
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(hostel.latitude!, hostel.longitude!),
        builder: (context) => _buildMarkerIcon(
          Icons.hotel,
          Theme.of(context).colorScheme.secondary,
          hostel.name,
        ),
      );
    }).toList();
  }

  Widget _buildMarkerIcon(IconData icon, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

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
            maxZoom: 18.0,
            minZoom: 3.0,
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
            // Add markers for events and hostels
            MarkerLayer(
              markers: [
                if (_showEvents) ..._buildEventMarkers(),
                if (_showHostels) ..._buildHostelMarkers(),
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
              child: const CustomNavbar(),
            ),
          ),
        ),

        // Layer toggles
        Positioned(
          top: MediaQuery.of(context).padding.top + 80,
          right: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLayerToggle(
                    'Events',
                    Icons.event,
                    _showEvents,
                    (value) => setState(() => _showEvents = value),
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  _buildLayerToggle(
                    'Hostels',
                    Icons.hotel,
                    _showHostels,
                    (value) => setState(() => _showHostels = value),
                    Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 8),
                  _buildLayerToggle(
                    'Facilities',
                    Icons.business,
                    _showFacilities,
                    (value) => setState(() => _showFacilities = value),
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Travel Assistant Chat
        if (_showChat)
          Positioned(
            bottom: 80,
            right: 16,
            child: TravelAssistantChat(
              geminiService: _geminiService,
              onClose: _toggleChat,
            ),
          ),

        // Floating Action Button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _toggleChat,
            icon: Icon(_showChat ? Icons.close : Icons.chat),
            label: Text(_showChat ? 'Close Assistant' : 'Travel Assistant'),
            tooltip: 'Chat with Travel Assistant',
          ),
        ),
      ],
    );
  }

  Widget _buildLayerToggle(
    String label,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(label),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
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
