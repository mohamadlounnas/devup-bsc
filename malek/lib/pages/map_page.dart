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

class Bus {
  final String id;
  final int delayMinutes; // Delay from first bus start time

  Bus({
    required this.id,
    required this.delayMinutes,
  });
}

class BusLine {
  final String name;
  final Color color;
  final List<Station> stations;
  final List<Bus> buses; // Add buses to BusLine

  BusLine({
    required this.name,
    required this.color,
    required this.stations,
    required this.buses,
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
      buses: [
        Bus(id: 'Bus 1A', delayMinutes: 0),
        Bus(id: 'Bus 1B', delayMinutes: 15),
        Bus(id: 'Bus 1C', delayMinutes: 30),
      ],
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
      buses: [
        Bus(id: 'Bus 2A', delayMinutes: 0),
        Bus(id: 'Bus 2B', delayMinutes: 20),
      ],
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
        final totalDuration = busLine.totalDuration;

        // Create animation controller and animation for each bus
        for (var bus in busLine.buses) {
          final controllerId = '${busLine.name}_${bus.id}';

          _animationControllers[controllerId] = AnimationController(
            vsync: this,
            duration: Duration(seconds: totalDuration),
          );

          final List<TweenSequenceItem<double>> sequences = [];
          double totalProgress = 0.0;

          for (int i = 0; i < busLine.stations.length - 1; i++) {
            final segmentWeight =
                (busLine.stations[i].minutesToNextStation / totalDuration) *
                    100;

            sequences.add(
              TweenSequenceItem(
                tween: Tween(
                  begin: totalProgress,
                  end: totalProgress +
                      (busLine.stations[i].minutesToNextStation /
                          totalDuration),
                ).chain(CurveTween(curve: Curves.linear)),
                weight: segmentWeight,
              ),
            );

            totalProgress +=
                busLine.stations[i].minutesToNextStation / totalDuration;
          }

          _animations[controllerId] = TweenSequence(sequences)
              .animate(_animationControllers[controllerId]!);

          // Start animation with delay
          Future.delayed(Duration(seconds: bus.delayMinutes), () {
            _animationControllers[controllerId]!.repeat(reverse: true);
          });
        }
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

  String _getNextBusTime(BusLine busLine, Station station,
      {bool isForward = true}) {
    // For first and last stations, we'll calculate both directions and use the maximum
    bool isFirstStation = station.order == 1;
    bool isLastStation = station.order == busLine.stations.length;

    if (isFirstStation || isLastStation) {
      int forwardTime = _calculateTimeForDirection(busLine, station, true);
      int reverseTime = _calculateTimeForDirection(busLine, station, false);

      // For first and last stations, use the maximum time
      int maxTime = max(forwardTime, reverseTime);
      return maxTime == 999999 ? '' : '$maxTime min';
    }

    // For other stations, calculate time based on direction
    return '${_calculateTimeForDirection(busLine, station, isForward)} min';
  }

  int _calculateTimeForDirection(
      BusLine busLine, Station station, bool isForward) {
    int shortestTime = 999999;

    // Check each bus in the line
    for (var bus in busLine.buses) {
      final controllerId = '${busLine.name}_${bus.id}';
      final controller = _animationControllers[controllerId];
      final animation = _animations[controllerId];

      if (controller == null || animation == null) continue;

      final totalDuration = busLine.totalDuration;
      double timeToStation = 0;
      int stationIndex = busLine.stations.indexOf(station);

      if (isForward) {
        // Calculate time to reach this station from start
        for (int i = 0; i < stationIndex; i++) {
          timeToStation += busLine.stations[i].minutesToNextStation;
        }

        // If we've passed this station, add full route time
        if (animation.value * totalDuration > timeToStation) {
          timeToStation += totalDuration;
        }
      } else {
        // Calculate time from end to this station
        for (int i = busLine.stations.length - 2; i >= stationIndex; i--) {
          timeToStation += busLine.stations[i].minutesToNextStation;
        }

        // If we've passed this station in reverse, add full route time
        if ((1 - animation.value) * totalDuration > timeToStation) {
          timeToStation += totalDuration;
        }
      }

      final minutes = (timeToStation -
              (isForward ? animation.value : (1 - animation.value)) *
                  totalDuration)
          .round();
      if (minutes < shortestTime) {
        shortestTime = minutes;
      }
    }

    return shortestTime;
  }

  Widget _buildTimingRow(BusLine busLine, Station station) {
    // Check if any animations are ready
    bool hasReadyAnimations = false;
    for (var bus in busLine.buses) {
      final controllerId = '${busLine.name}_${bus.id}';
      if (_animationControllers[controllerId] != null &&
          _animations[controllerId] != null) {
        hasReadyAnimations = true;
        break;
      }
    }

    if (!hasReadyAnimations) {
      return const SizedBox.shrink();
    }

    bool isFirstStation = station.order == 1;
    bool isLastStation = station.order == busLine.stations.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Forward direction
        Expanded(
          child: Row(
            children: [
              Icon(Icons.arrow_forward, size: 14, color: busLine.color),
              const SizedBox(width: 4),
              AnimatedBuilder(
                animation: Listenable.merge(
                  busLine.buses
                      .map((bus) =>
                          _animationControllers['${busLine.name}_${bus.id}'])
                      .whereType<AnimationController>()
                      .toList(),
                ),
                builder: (context, _) {
                  String time =
                      _getNextBusTime(busLine, station, isForward: true);
                  // For first or last station, show the same time in both directions
                  if (isFirstStation || isLastStation) {
                    time = _getNextBusTime(busLine, station,
                        isForward:
                            true); // The isForward parameter doesn't matter here as we take max
                  }
                  return Text(
                    time,
                    style: TextStyle(
                      color: busLine.color,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Reverse direction
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge(
                  busLine.buses
                      .map((bus) =>
                          _animationControllers['${busLine.name}_${bus.id}'])
                      .whereType<AnimationController>()
                      .toList(),
                ),
                builder: (context, _) {
                  String time =
                      _getNextBusTime(busLine, station, isForward: false);
                  // For first or last station, show the same time in both directions
                  if (isFirstStation || isLastStation) {
                    time = _getNextBusTime(busLine, station,
                        isForward:
                            true); // The isForward parameter doesn't matter here as we take max
                  }
                  return Text(
                    time,
                    style: TextStyle(
                      color: busLine.color,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_back, size: 14, color: busLine.color),
            ],
          ),
        ),
      ],
    );
  }

  // Update the table in the drawer
  Widget _buildStationTable(BusLine busLine) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(3), // More space for station names
        1: FlexColumnWidth(4), // More space for timing info
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: busLine.color.withOpacity(0.1),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Station',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: busLine.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_forward, size: 18, color: busLine.color),
                      const SizedBox(width: 8),
                      Text(
                        'Going',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: busLine.color,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Return',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: busLine.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_back, size: 18, color: busLine.color),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        for (var station in busLine.stations)
          TableRow(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildTimingRow(busLine, station),
              ),
            ],
          ),
      ],
    );
  }

  // Update the drawer content
  Widget _buildDrawerContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade100,
          child: const Row(
            children: [
              Icon(Icons.schedule),
              SizedBox(width: 16),
              Text(
                'Bus Schedule',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var busLine in busLines) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.directions_bus, color: busLine.color),
                        const SizedBox(width: 8),
                        Text(
                          busLine.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: busLine.color,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStationTable(busLine),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boumerdes Transport Lines'),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
        child: SafeArea(
          child: _buildDrawerContent(),
        ),
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
                      if (busRoutes.containsKey(busLine.name))
                        for (var bus in busLine.buses)
                          if (_animations
                              .containsKey('${busLine.name}_${bus.id}'))
                            Marker(
                              point: _calculatePosition(
                                busRoutes[busLine.name]!,
                                _animations['${busLine.name}_${bus.id}']!.value,
                                busLine.name,
                              ),
                              width: 30,
                              height: 30,
                              child: RepaintBoundary(
                                child: Stack(
                                  children: [
                                    Container(
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
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          bus.id.split(' ')[
                                              1], // Show bus number (1A, 1B, etc.)
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: busLine.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
    // Find which bus line and station this marker belongs to
    BusLine? busLine;
    Station? station;
    for (var line in busLines) {
      for (var s in line.stations) {
        if (s.location == point) {
          busLine = line;
          station = s;
          break;
        }
      }
      if (station != null) break;
    }

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
              child: Column(
                children: [
                  Text(
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
                  if (busLine != null &&
                      station != null &&
                      _animationControllers[busLine.name] != null &&
                      _animations[busLine.name] != null)
                    Text(
                      _getNextBusTime(busLine, station),
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
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
