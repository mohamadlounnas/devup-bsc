import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Station {
  final String name;
  final LatLng location;
  final int order;
  final int minutesToNextStation; // Time to next station in minutes

  Station({
    required this.name,
    required this.location,
    required this.order,
    this.minutesToNextStation = 0, // Default to 0 for last station
  });
}

class BusLine {
  final String name;
  final Color color;
  final List<Station> stations;

  BusLine({
    required this.name,
    required this.color,
    required this.stations,
  });

  List<LatLng> get stationPoints =>
      stations.map((station) => station.location).toList();

  // Get total route duration in minutes
  int get totalDuration {
    int total = 0;
    for (int i = 0; i < stations.length - 1; i++) {
      total += stations[i].minutesToNextStation;
    }
    return total;
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  Map<String, List<LatLng>> busRoutes = {};
  bool isLoading = true;
  Map<String, AnimationController> _animationControllers = {};
  Map<String, Animation<double>> _animations = {};
  // Cache for route distances
  final Map<String, double> _routeDistanceCache = {};
  // Cache for markers
  late final List<Marker> _staticMarkers;

  // Define bus lines with ordered stations
  final List<BusLine> busLines = [
    BusLine(
      name: 'Bus Line 1',
      color: Colors.blue,
      stations: [
        Station(
          name: '350 logment',
          location: LatLng(36.778389720373795, 3.5204455468033298),
          order: 1,
          minutesToNextStation: 5,
        ),
        Station(
          name: 'Le figuier (2eme)',
          location: LatLng(36.77332779573822, 3.516027043465134),
          order: 2,
          minutesToNextStation: 4,
        ),
        Station(
          name: 'Zitouna',
          location: LatLng(36.77007621139096, 3.5111758389758014),
          order: 3,
          minutesToNextStation: 6,
        ),
        Station(
          name: 'Sahel',
          location: LatLng(36.76792188317149, 3.5021636173405972),
          order: 4,
          minutesToNextStation: 5,
        ),
        Station(
          name: 'Nakhlat',
          location: LatLng(36.76591074049401, 3.495132653333753),
          order: 5,
          minutesToNextStation: 4,
        ),
        Station(
          name: 'Tchina',
          location: LatLng(36.76444482260056, 3.4868012937408577),
          order: 6,
          minutesToNextStation: 7,
        ),
        Station(
          name: 'Cous université',
          location: LatLng(36.764727900774886, 3.476396797107724),
          order: 7,
          minutesToNextStation: 0, // Last station
        ),
      ],
    ),
    BusLine(
      name: 'Bus Line 2',
      color: Colors.red,
      stations: [
        Station(
          name: 'UMBB',
          location: LatLng(36.76654857851268, 3.4719006332205367),
          order: 1,
          minutesToNextStation: 8,
        ),
        Station(
          name: 'Plage',
          location: LatLng(36.7650, 3.4820),
          order: 2,
          minutesToNextStation: 6,
        ),
        Station(
          name: 'Cité 800',
          location: LatLng(36.7600, 3.4770),
          order: 3,
          minutesToNextStation: 0, // Last station
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize static markers
    _staticMarkers = [
      for (var busLine in busLines)
        for (var station in busLine.stations)
          _buildMarker(station.location, station.name, busLine.color),
    ];
    _loadRoutes();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setupAnimations() {
    for (var busLine in busLines) {
      if (busRoutes.containsKey(busLine.name)) {
        // Total duration in seconds (1 minute = 1 second in animation)
        final totalDuration = busLine.totalDuration;

        _animationControllers[busLine.name] = AnimationController(
          vsync: this,
          duration: Duration(seconds: totalDuration),
        )..repeat(reverse: true);

        // Create a sequence of animations for each segment with proportional durations
        final List<TweenSequenceItem<double>> sequences = [];
        double totalProgress = 0.0;

        for (int i = 0; i < busLine.stations.length - 1; i++) {
          // Calculate segment weight based on time to next station
          final segmentWeight =
              (busLine.stations[i].minutesToNextStation / totalDuration) * 100;

          sequences.add(
            TweenSequenceItem(
              tween: Tween(
                begin: totalProgress,
                end: totalProgress +
                    (busLine.stations[i].minutesToNextStation / totalDuration),
              ).chain(CurveTween(curve: Curves.linear)),
              weight: segmentWeight,
            ),
          );

          totalProgress +=
              busLine.stations[i].minutesToNextStation / totalDuration;
        }

        _animations[busLine.name] = TweenSequence(sequences)
            .animate(_animationControllers[busLine.name]!);
      }
    }
  }

  Future<List<LatLng>> getRouteBetweenStops(Station start, Station end) async {
    try {
      final response = await http.get(Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/${start.location.longitude},${start.location.latitude};${end.location.longitude},${end.location.latitude}?steps=true&geometries=geojson&overview=full'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;
          return coordinates
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();
        }
      }
    } catch (e) {
      // Error handling without logging
    }

    // Fallback to direct line if route not found
    return [start.location, end.location];
  }

  double _getRouteDistance(String routeName) {
    return _routeDistanceCache[routeName] ??=
        _calculateTotalDistance(busRoutes[routeName]!);
  }

  LatLng _calculatePosition(
      List<LatLng> route, double progress, String routeName) {
    final totalDistance = _getRouteDistance(routeName);
    final targetDistance = totalDistance * progress;

    double currentDistance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      final segmentDistance = _calculateDistance(route[i], route[i + 1]);
      if (currentDistance + segmentDistance >= targetDistance) {
        final segmentProgress =
            (targetDistance - currentDistance) / segmentDistance;
        return _interpolatePoints(route[i], route[i + 1], segmentProgress);
      }
      currentDistance += segmentDistance;
    }
    return route.last;
  }

  double _calculateTotalDistance(List<LatLng> route) {
    double total = 0;
    for (int i = 0; i < route.length - 1; i++) {
      total += _calculateDistance(route[i], route[i + 1]);
    }
    return total;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double radius = 6371e3; // Earth's radius in meters
    final phi1 = point1.latitude * pi / 180;
    final phi2 = point2.latitude * pi / 180;
    final deltaPhi = (point2.latitude - point1.latitude) * pi / 180;
    final deltaLambda = (point2.longitude - point1.longitude) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  LatLng _interpolatePoints(LatLng start, LatLng end, double progress) {
    return LatLng(
      start.latitude + (end.latitude - start.latitude) * progress,
      start.longitude + (end.longitude - start.longitude) * progress,
    );
  }

  Future<void> _loadRoutes() async {
    for (var busLine in busLines) {
      List<LatLng> fullRoute = [];

      for (int i = 0; i < busLine.stations.length - 1; i++) {
        final route = await getRouteBetweenStops(
          busLine.stations[i],
          busLine.stations[i + 1],
        );

        if (fullRoute.isEmpty) {
          fullRoute.addAll(route);
        } else {
          fullRoute.addAll(route.skip(1));
        }
      }

      busRoutes[busLine.name] = fullRoute;
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
      _setupAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boumerdes Transport Lines'),
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            RepaintBoundary(
              child: AnimatedBuilder(
                animation:
                    Listenable.merge(_animationControllers.values.toList()),
                builder: (context, child) {
                  final List<Marker> allMarkers = [
                    ..._staticMarkers,
                    // Only animate bus markers
                    for (var busLine in busLines)
                      if (busRoutes.containsKey(busLine.name) &&
                          _animations.containsKey(busLine.name))
                        Marker(
                          point: _calculatePosition(
                            busRoutes[busLine.name]!,
                            _animations[busLine.name]!.value,
                            busLine.name,
                          ),
                          width: 30,
                          height: 30,
                          child: RepaintBoundary(
                            child: Container(
                              decoration: BoxDecoration(
                                color: busLine.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.directions_bus,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                  ];

                  return FlutterMap(
                    options: MapOptions(
                      center: busLines[0].stations[2].location,
                      zoom: 15,
                      maxZoom: 18,
                      minZoom: 3,
                      onTap: (tapPosition, point) {
                        // Removed tap logging
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      PolylineLayer(
                        polylines: [
                          for (var busLine in busLines)
                            if (busRoutes.containsKey(busLine.name))
                              Polyline(
                                points: busRoutes[busLine.name]!,
                                color: busLine.color,
                                strokeWidth: 4.0,
                                isDotted: true,
                              ),
                        ],
                      ),
                      MarkerLayer(
                        markers: allMarkers,
                      ),
                    ],
                  );
                },
              ),
            ),
          // Legend
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transport Lines',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...busLines.map((busLine) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.directions_bus,
                                color: busLine.color, size: 24),
                            const SizedBox(width: 8),
                            Text(busLine.name),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(LatLng point, String label, Color color) {
    return Marker(
      point: point,
      width: 100,
      height: 100,
      child: GestureDetector(
        onTap: () {
          // Removed coordinate logging
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              constraints: const BoxConstraints(maxWidth: 90),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: color, width: 1),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                Icons.directions_bus,
                color: color,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
