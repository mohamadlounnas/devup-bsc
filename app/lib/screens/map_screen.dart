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
import 'package:app/providers/facilities_provider.dart';
import 'package:app/screens/events/widgets/event_details_panel.dart';
import 'package:app/screens/hostels/widgets/hostel_details_panel.dart';
import 'package:app/screens/facilities/widgets/facility_details_panel.dart';
import 'package:intl/intl.dart';

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
  late final FacilitiesProvider _facilitiesProvider;

  // Filter states
  bool _showEvents = true;
  bool _showHostels = true;
  bool _showFacilities = true;

  // Selected items
  FacilityEvent? _selectedEvent;
  Hostel? _selectedHostel;
  Facility? _selectedFacility;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with your Gemini API key
    _geminiService =
        GeminiService(apiKey: 'AIzaSyBFaNgOZlD--RtxezGxoLDPSaXEo8PcEX8');
    _eventsProvider = EventsProvider();
    _hostelsProvider = HostelsProvider();
    _facilitiesProvider = FacilitiesProvider();

    // Load data
    Future.wait([
      _eventsProvider.subscribeToEvents(),
      _hostelsProvider.loadHostels(),
      _facilitiesProvider.loadFacilities(),
    ]).then((value) {
      if (_eventsProvider.events.isNotEmpty)
        _mapController.move(
          LatLng(
            _eventsProvider.events.first.locationLatLng!.latitude,
            _eventsProvider.events.first.locationLatLng!.longitude,
          ),
          13.0,
        );
    });
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _hostelsProvider.dispose();
    _facilitiesProvider.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  void _showEventDetails(FacilityEvent event) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;

    if (isWideScreen) {
      setState(() => _selectedEvent = event);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => EventDetailsPanel(
            event: event,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  void _showHostelDetails(Hostel hostel) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;

    if (isWideScreen) {
      setState(() => _selectedHostel = hostel);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => HostelDetailsPanel(
            hostel: hostel,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  void _showFacilityDetails(Facility facility) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;

    if (isWideScreen) {
      setState(() => _selectedFacility = facility);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => FacilityDetailsPanel(
            facility: facility,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  List<Marker> _buildEventMarkers() {
    return _eventsProvider.events.where((event) {
      return event.locationLatLng != null;
    }).map((event) {
      final isSelected = event == _selectedEvent;
      return Marker(
        point: event.locationLatLng!,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showEventDetails(event),
          child: _buildMarkerIcon(
            Icons.event,
            Theme.of(context).colorScheme.primary,
            event.name,
            isSelected: isSelected,
          ),
        ),
      );
    }).toList();
  }

  List<Marker> _buildHostelMarkers() {
    return _hostelsProvider.hostels.where((hostel) {
      return hostel.latLong != null;
    }).map((hostel) {
      final isSelected = hostel == _selectedHostel;
      return Marker(
        point: hostel.latLong!,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showHostelDetails(hostel),
          child: _buildMarkerIcon(
            Icons.hotel,
            Theme.of(context).colorScheme.secondary,
            hostel.name,
            isSelected: isSelected,
          ),
        ),
      );
    }).toList();
  }

  List<Marker> _buildFacilityMarkers() {
    return _facilitiesProvider.facilities.where((facility) {
      return facility.locationLatLng != null;
    }).map((facility) {
      final isSelected = facility == _selectedFacility;
      return Marker(
        point: facility.locationLatLng!,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showFacilityDetails(facility),
          child: _buildMarkerIcon(
            _getFacilityIcon(facility.type),
            Theme.of(context).colorScheme.tertiary,
            facility.name,
            isSelected: isSelected,
          ),
        ),
      );
    }).toList();
  }

  IconData _getFacilityIcon(FacilityType type) {
    switch (type) {
      case FacilityType.sportClub:
        return Icons.sports;
      case FacilityType.touristAgency:
        return Icons.tour;
      case FacilityType.hotel:
        return Icons.hotel;
      case FacilityType.museum:
        return Icons.museum;
      case FacilityType.restaurant:
        return Icons.restaurant;
    }
  }

  Widget _buildMarkerIcon(
    IconData icon,
    Color color,
    String tooltip, {
    bool isSelected = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 1.0 + (value * 0.2),
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3 + (value * 0.2)),
                    blurRadius: 8 + (value * 8),
                    spreadRadius: 2 + (value * 2),
                  ),
                ],
                border: isSelected
                    ? Border.all(
                        color: Colors.white,
                        width: 2,
                      )
                    : null,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;

    return ListenableBuilder(
        listenable: Listenable.merge([
          _eventsProvider,
          _hostelsProvider,
          _facilitiesProvider,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              // Full screen map
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  // center on Boumerdes (wilaya of algeria)
                  center: const LatLng(36.7525, 3.0420),
                  zoom: 13.0,
                  maxZoom: 18.0,
                  minZoom: 3.0,
                  onTap: (_, __) {
                    // Deselect items when tapping the map
                    setState(() {
                      _selectedEvent = null;
                      _selectedHostel = null;
                      _selectedFacility = null;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    tileProvider: CachedTileProvider(),
                  ),
                  // Draw Boumerdes borders using polygon
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: [
                          LatLng(36.7525, 3.0420),
                          LatLng(36.7525, 3.0420),
                          LatLng(36.7525, 3.0420),
                        ],
                      ),
                    ],
                  ),
                  // Add markers for events and hostels
                  MarkerLayer(
                    markers: [
                      if (_showEvents) ..._buildEventMarkers(),
                      if (_showHostels) ..._buildHostelMarkers(),
                      if (_showFacilities) ..._buildFacilityMarkers(),
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

              // Details panels for wide screen
              if (isWideScreen) ...[
                if (_selectedEvent != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 80,
                    right: 80,
                    bottom: 16,
                    width: 400,
                    child: Card(
                      elevation: 4,
                      child: EventDetailsPanel(
                        event: _selectedEvent!,
                        isSideSheet: true,
                        onClose: () => setState(() => _selectedEvent = null),
                      ),
                    ),
                  ),
                if (_selectedHostel != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 80,
                    right: 80,
                    bottom: 16,
                    width: 400,
                    child: Card(
                      elevation: 4,
                      child: HostelDetailsPanel(
                        hostel: _selectedHostel!,
                        isSideSheet: true,
                        onClose: () => setState(() => _selectedHostel = null),
                      ),
                    ),
                  ),
                if (_selectedFacility != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 80,
                    right: 80,
                    bottom: 16,
                    width: 400,
                    child: Card(
                      elevation: 4,
                      child: FacilityDetailsPanel(
                        facility: _selectedFacility!,
                        isSideSheet: true,
                        onClose: () => setState(() => _selectedFacility = null),
                      ),
                    ),
                  ),
              ],

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
                bottom: 70,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: _toggleChat,
                  icon: Icon(_showChat ? Icons.close : Icons.chat),
                  label:
                      Text(_showChat ? 'Close Assistant' : 'Travel Assistant'),
                  tooltip: 'Chat with Travel Assistant',
                ),
              ),
            ],
          );
        });
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
