import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:app/providers/events_provider.dart';
import 'package:app/providers/facilities_provider.dart';
import 'package:app/providers/hostels_provider.dart';
import 'package:app/widgets/event_card.dart';
import 'package:app/widgets/facility_card.dart';
import 'package:app/screens/hostels/widgets/hostel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cached_tile_provider/flutter_map_cached_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:osrm/osrm.dart';
import 'package:shared/shared.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';

/// A screen that displays an interactive map with facilities, hostels and events.
/// Shows current user location, markers for points of interest, and allows route calculation.
class MapScreen extends StatefulWidget {
  /// Creates a new [MapScreen] instance
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // Controllers
  late final MapController _mapController;
  final ScrollController _scrollController = ScrollController();
  
  // Providers
  late final EventsProvider _eventsProvider;
  late final FacilitiesProvider _facilitiesProvider;
  late final HostelsProvider _hostelsProvider;
  
  // Location and routing
  Position? _currentPosition;
  final ValueNotifier<LatLng?> _selectedPoint = ValueNotifier(null);
  final ValueNotifier<OsrmRoute?> _route = ValueNotifier(null);
  final Osrm _osrm = Osrm();

  // Data and loading states
  List<Facility> get _facilities => _facilitiesProvider.facilities;
  List<Hostel> get _hostels => _hostelsProvider.hostels;
  List<FacilityEvent> get _events => _eventsProvider.events;
  bool _isLoading = true;
  String? _error;
  
  // Selected item tracking
  final ValueNotifier<Object?> _selectedItem = ValueNotifier(null);

  // Default location (Boumerdes)
  static const LatLng _defaultLocation = LatLng(36.7525, 3.0420);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _eventsProvider = EventsProvider();
    _facilitiesProvider = FacilitiesProvider();
    _hostelsProvider = HostelsProvider();
    _initializeData();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _scrollController.dispose();
    _selectedPoint.dispose();
    _route.dispose();
    _selectedItem.dispose();
    _eventsProvider.dispose();
    _facilitiesProvider.dispose();
    _hostelsProvider.dispose();
    super.dispose();
  }

  /// Initialize location and data
  Future<void> _initializeData() async {
    try {
      setState(() => _isLoading = true);
      
      // Get location permission and current position
      await _getCurrentLocation();
      
      // Load data from providers
      await Future.wait([
        _eventsProvider.subscribeToEvents(),
        _facilitiesProvider.loadFacilities(),
        _hostelsProvider.loadHostels(),
      ]);
      
      // Setup scroll listener after data is loaded
      _setupScrollListener();
      
      setState(() {
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  /// Get current user location after requesting permissions
  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      
      setState(() {
        _currentPosition = position;
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          13.0,
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      rethrow;
    }
  }

  /// Setup scroll controller to handle card scrolling
  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      
      final itemWidth = MediaQuery.of(context).size.width * 0.85;
      final offset = _scrollController.offset;
      final index = (offset / itemWidth).round();
      
      final item = _getItemAtIndex(index);
      if (item != null && item != _selectedItem.value) {
        _selectedItem.value = item;
        _centerMapOnItem(item);
      }
    });
  }

  /// Get the item (Facility/Hostel/Event) at the given index
  Object? _getItemAtIndex(int index) {
    if (index < 0) return null;
    
    if (index < _facilities.length) {
      return _facilities[index];
    }
    index -= _facilities.length;
    
    if (index < _hostels.length) {
      return _hostels[index];
    }
    index -= _hostels.length;
    
    if (index < _events.length) {
      return _events[index];
    }
    
    return null;
  }

  /// Get location for a given item
  LatLng? _getItemLocation(Object item) {
    if (item is Facility) {
      final coords = item.location?.split(',');
      if (coords?.length == 2) {
        return LatLng(
          double.tryParse(coords![0]) ?? 0,
          double.tryParse(coords[1]) ?? 0,
        );
      }
    } else if (item is Hostel) {
      return item.latLong;
    } else if (item is FacilityEvent) {
      final coords = item.location?.split(',');
      if (coords?.length == 2) {
        return LatLng(
          double.tryParse(coords![0]) ?? 0,
          double.tryParse(coords[1]) ?? 0,
        );
      }
    }
    return null;
  }

  /// Center the map on the given item
  void _centerMapOnItem(Object item) {
    final location = _getItemLocation(item);
    if (location != null) {
      _mapController.move(location, 15);
      if (_currentPosition != null) {
        _calculateRoute(location);
      }
    }
  }

  /// Share item details
  Future<void> _shareItem(Object item) async {
    try {
      String text;
      if (item is Facility) {
        text = '${item.name}\n${item.description}\nLocation: ${item.location}';
      } else if (item is Hostel) {
        text = '${item.name}\nAddress: ${item.address}\nCapacity: ${item.capacity} beds';
      } else if (item is FacilityEvent) {
        text = '${item.name}\n${item.description}\nLocation: ${item.location}';
      } else {
        return;
      }
      
      await Share.share(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $e')),
      );
    }
  }

  /// Calculate route between current location and destination
  Future<void> _calculateRoute(LatLng destination) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current location not available')),
      );
      return;
    }

    try {
      final response = await _osrm.route(
        RouteRequest(
          coordinates: [
            (_currentPosition!.latitude, _currentPosition!.longitude),
            (destination.latitude, destination.longitude),
          ],
          geometries: OsrmGeometries.geojson,
          overview: OsrmOverview.full,
          steps: true,
        ),
      );

      if (!mounted) return;

      if (response.routes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No route found')),
        );
        return;
      }

      _route.value = response.routes.first;
      
      final points = response.routes.first.geometry!.lineString!.coordinates
          .map((e) => LatLng(e.$2, e.$1))
          .toList();
      
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitBounds(
        bounds,
        options: const FitBoundsOptions(padding: EdgeInsets.all(50.0)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to calculate route: $e')),
      );
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    
    final itemWidth = MediaQuery.of(context).size.width * 0.85;
    _scrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializeData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition != null 
                ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                : _defaultLocation,
              zoom: 13.0,
              onTap: (_, point) {
                _selectedPoint.value = point;
                _calculateRoute(point);
              },
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: CachedTileProvider(),
              ),

              // Route polyline layer
              ValueListenableBuilder<OsrmRoute?>(
                valueListenable: _route,
                builder: (context, route, _) {
                  if (route?.geometry?.lineString == null) {
                    return const SizedBox.shrink();
                  }
                  
                  final points = route!.geometry!.lineString!.coordinates
                      .map((e) => LatLng(e.$2, e.$1))
                      .toList();

                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 4,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  );
                },
              ),

              // Markers layer
              MarkerLayer(
                markers: [
                  // Current location marker
                  if (_currentPosition != null)
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      child: const _PulsingLocationMarker(),
                    ),

                  // Facility markers
                  ..._facilities.map((facility) {
                    final location = _getItemLocation(facility);
                    if (location == null) return const Marker(
                      point: _defaultLocation,
                      child: SizedBox.shrink(),
                    );
                    
                    return Marker(
                      point: location,
                      child: _MarkerIcon(
                        icon: Icons.business,
                        color: Colors.blue,
                        onTap: () {
                          _selectedItem.value = facility;
                          final index = _facilities.indexOf(facility);
                          _scrollToIndex(index);
                        },
                      ),
                    );
                  }),

                  // Hostel markers
                  ..._hostels.map((hostel) => Marker(
                    point: hostel.latLong ?? _defaultLocation,
                    child: _MarkerIcon(
                      icon: Icons.hotel,
                      color: Colors.green,
                      onTap: () {
                        _selectedItem.value = hostel;
                        final index = _facilities.length + _hostels.indexOf(hostel);
                        _scrollToIndex(index);
                      },
                    ),
                  )),

                  // Event markers
                  ..._events.map((event) {
                    final location = _getItemLocation(event);
                    if (location == null) return const Marker(
                      point: _defaultLocation,
                      child: SizedBox.shrink(),
                    );
                    
                    return Marker(
                      point: location,
                      child: _MarkerIcon(
                        icon: Icons.event,
                        color: Colors.orange,
                        onTap: () {
                          _selectedItem.value = event;
                          final index = _facilities.length + _hostels.length + 
                              _events.indexOf(event);
                          _scrollToIndex(index);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Bottom cards
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 220,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _facilities.length + _hostels.length + _events.length,
                itemBuilder: (context, index) {
                  final item = _getItemAtIndex(index);
                  if (item == null) return const SizedBox.shrink();
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ValueListenableBuilder<Object?>(
                        valueListenable: _selectedItem,
                        builder: (context, selectedItem, _) {
                          final isSelected = selectedItem == item;
                          
                          Widget card;
                          if (item is Facility) {
                            card = FacilityCard(
                              facility: item,
                              onTap: () => _selectedItem.value = item,
                              onShare: () => _shareItem(item),
                              onGetDirections: () {
                                final location = _getItemLocation(item);
                                if (location != null) {
                                  _calculateRoute(location);
                                }
                              },
                            );
                          } else if (item is Hostel) {
                            card = HostelCard(
                              hostel: item,
                              isGridView: false,
                              onTap: () => _selectedItem.value = item,
                              onShare: () => _shareItem(item),
                              onGetDirections: () {
                                if (item.latLong != null) {
                                  _calculateRoute(item.latLong!);
                                }
                              },
                            );
                          } else if (item is FacilityEvent) {
                            card = EventCard(event: item);
                          } else {
                            card = const SizedBox.shrink();
                          }
                          
                          return AnimatedScale(
                            scale: isSelected ? 1.0 : 0.95,
                            duration: const Duration(milliseconds: 200),
                            child: card,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Top navigation bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: _getCurrentLocation,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A pulsing animation for the current location marker
class _PulsingLocationMarker extends StatefulWidget {
  const _PulsingLocationMarker();

  @override
  State<_PulsingLocationMarker> createState() => _PulsingLocationMarkerState();
}

class _PulsingLocationMarkerState extends State<_PulsingLocationMarker> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            Center(
              child: Container(
                width: 30 * (1 + _animation.value),
                height: 30 * (1 + _animation.value),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A custom marker icon with tap handling
class _MarkerIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MarkerIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
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
}
