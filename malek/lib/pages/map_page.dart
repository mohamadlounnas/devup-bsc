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

class PointOfInterest {
  final String name;
  final LatLng location;
  final IconData icon;
  final String type;

  PointOfInterest({
    required this.name,
    required this.location,
    required this.icon,
    required this.type,
  });
}

class Train {
  final String id;
  final int delayMinutes;

  Train({
    required this.id,
    required this.delayMinutes,
  });
}

class TrainLine {
  final String name;
  final Color color;
  final List<Station> stations;
  final List<Train> trains;

  TrainLine({
    required this.name,
    required this.color,
    required this.stations,
    required this.trains,
  });

  List<LatLng> get stationPoints =>
      stations.map((station) => station.location).toList();

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

  final Map<String, bool> _poiToggles = {
    'mosques': false,
    'toilets': false,
    'parking': false,
    'restaurants': false,
  };

  final List<PointOfInterest> _pois = [
    // Mosques
    PointOfInterest(
      name: 'Mosquée El-Forqane',
      location: LatLng(36.7672, 3.4762), // Near university area
      icon: Icons.mosque,
      type: 'mosques',
    ),
    PointOfInterest(
      name: 'Mosquée El-Taqwa',
      location: LatLng(36.7645, 3.4805), // Near city center
      icon: Icons.mosque,
      type: 'mosques',
    ),
    PointOfInterest(
      name: 'Mosquée El-Rahma',
      location: LatLng(36.7715, 3.5140), // In residential area
      icon: Icons.mosque,
      type: 'mosques',
    ),

    // Public Toilets
    PointOfInterest(
      name: 'WC Public Plage',
      location: LatLng(36.7635, 3.4835), // Near beach area
      icon: Icons.wc,
      type: 'toilets',
    ),
    PointOfInterest(
      name: 'WC Station',
      location: LatLng(36.7668, 3.4745), // Near bus station
      icon: Icons.wc,
      type: 'toilets',
    ),
    PointOfInterest(
      name: 'WC Centre Commercial',
      location: LatLng(36.7655, 3.4775), // Shopping center
      icon: Icons.wc,
      type: 'toilets',
    ),

    // Parking Areas
    PointOfInterest(
      name: 'Parking UMBB',
      location: LatLng(36.7675, 3.4725), // University parking
      icon: Icons.local_parking,
      type: 'parking',
    ),
    PointOfInterest(
      name: 'Parking Centre Ville',
      location: LatLng(36.7648, 3.4768), // Downtown parking
      icon: Icons.local_parking,
      type: 'parking',
    ),
    PointOfInterest(
      name: 'Parking Plage',
      location: LatLng(36.7628, 3.4828), // Beach parking
      icon: Icons.local_parking,
      type: 'parking',
    ),

    // Restaurants
    PointOfInterest(
      name: 'Restaurant Zitouna',
      location: LatLng(36.7695, 3.5105), // Near Zitouna area
      icon: Icons.restaurant,
      type: 'restaurants',
    ),
    PointOfInterest(
      name: 'Fast Food Le Spot',
      location: LatLng(36.7642, 3.4758), // City center
      icon: Icons.restaurant,
      type: 'restaurants',
    ),
    PointOfInterest(
      name: 'Restaurant La Marina',
      location: LatLng(36.7632, 3.4815), // Near beach
      icon: Icons.restaurant,
      type: 'restaurants',
    ),
    PointOfInterest(
      name: 'Pizza Sahel',
      location: LatLng(36.7685, 3.5015), // Sahel area
      icon: Icons.restaurant,
      type: 'restaurants',
    ),
    PointOfInterest(
      name: 'Café Central',
      location: LatLng(36.7652, 3.4772), // City center
      icon: Icons.restaurant,
      type: 'restaurants',
    ),
  ];

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

  // Add this map to define colors for each POI type
  final Map<String, Color> _poiColors = {
    'mosques': Color(0xFF1E88E5), // Blue
    'toilets': Color(0xFF43A047), // Green
    'parking': Color(0xFFE53935), // Red
    'restaurants': Color(0xFFFF9800), // Orange
    'buses': Colors.blue,
    'trains': Colors.purple,
  };

  // Add this to the _MapPageState class properties
  final List<TrainLine> trainLines = [
    TrainLine(
      name: 'Train Line 1',
      color: Colors.purple,
      trains: [
        Train(id: 'Train 1→', delayMinutes: 0), // Starts from Boumerdes
        Train(
            id: 'Train 1←',
            delayMinutes: 0), // Starts from Thénia (both start at same time)
      ],
      stations: [
        Station(
          name: 'Boumerdes Gare',
          location: LatLng(36.7665, 3.4719),
          order: 1,
          minutesToNextStation:
              25, // Increased time for more realistic train journey
        ),
        Station(
          name: 'Corso Gare',
          location: LatLng(36.7338, 3.4453),
          order: 2,
          minutesToNextStation: 30,
        ),
        Station(
          name: 'Thénia Gare',
          location: LatLng(36.7248, 3.5547),
          order: 3,
          minutesToNextStation: 0,
        ),
      ],
    ),
    TrainLine(
      name: 'Train Line 2',
      color: Colors.deepPurple,
      trains: [
        Train(id: 'Train 2→', delayMinutes: 0), // Starts from Boumerdes
        Train(
            id: 'Train 2←',
            delayMinutes:
                0), // Starts from Rocher Noir (both start at same time)
      ],
      stations: [
        Station(
          name: 'Boumerdes Gare',
          location: LatLng(36.7665, 3.4719),
          order: 1,
          minutesToNextStation: 28,
        ),
        Station(
          name: 'Tidjelabine Gare',
          location: LatLng(36.7372, 3.4986),
          order: 2,
          minutesToNextStation: 26,
        ),
        Station(
          name: 'Rocher Noir Gare',
          location: LatLng(36.7475, 3.5214),
          order: 3,
          minutesToNextStation: 0,
        ),
      ],
    ),
  ];

  // Add these properties to _MapPageState class
  final Map<String, bool> _transportToggles = {
    'buses': true,
    'trains': true,
  };

  // Add this to _MapPageState class
  bool _showBusSchedule = true;

  @override
  void initState() {
    super.initState();
    _staticMarkers = [
      for (var busLine in busLines)
        for (var station in busLine.stations)
          _buildMarker(station.location, station.name, busLine.color),
      for (var trainLine in trainLines)
        for (var station in trainLine.stations)
          _buildMarker(station.location, station.name, trainLine.color,
              isTrainStation: true),
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
    // Setup bus animations
    for (var busLine in busLines) {
      _setupLineAnimations(busLine.name, busLine.totalDuration, busLine.buses);
    }

    // Setup train animations
    for (var trainLine in trainLines) {
      _setupLineAnimations(
          trainLine.name, trainLine.totalDuration, trainLine.trains);
    }
  }

  void _setupLineAnimations(
      String lineName, int totalDuration, List<dynamic> vehicles) {
    if (busRoutes.containsKey(lineName)) {
      for (var vehicle in vehicles) {
        final controllerId = '${lineName}_${vehicle.id}';
        final isTrainVehicle = vehicle is Train;
        final isReturnDirection = isTrainVehicle && vehicle.id.contains('←');

        // Make trains move slower
        final adjustedDuration = isTrainVehicle
            ? Duration(seconds: totalDuration * 4) // Trains move 4x slower
            : Duration(seconds: totalDuration);

        _animationControllers[controllerId] = AnimationController(
          vsync: this,
          duration: adjustedDuration,
        );

        if (isTrainVehicle) {
          // For trains, start from opposite ends
          _animations[controllerId] = Tween(
            begin: isReturnDirection ? 1.0 : 0.0,
            end: isReturnDirection ? 0.0 : 1.0,
          ).animate(
            CurvedAnimation(
              parent: _animationControllers[controllerId]!,
              curve: Curves.linear,
            ),
          );

          // Start trains immediately (no delay)
          _animationControllers[controllerId]!.repeat();
        } else {
          // Keep existing bus animation
          _animations[controllerId] = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationControllers[controllerId]!,
              curve: Curves.linear,
            ),
          );

          // Only buses have delays
          Future.delayed(Duration(seconds: vehicle.delayMinutes), () {
            _animationControllers[controllerId]!.repeat(reverse: true);
          });
        }
      }
    }
  }

  Future<List<LatLng>> getRouteBetweenStops(Station start, Station end,
      {bool isTrainRoute = false}) async {
    if (isTrainRoute) {
      // For trains, use straight lines or predefined railway paths
      return [
        start.location,
        // Add intermediate points to better represent railway curves
        if (start.name == 'Boumerdes Gare' && end.name == 'Corso Gare')
          LatLng(36.7520, 3.4580), // Example curve point
        if (start.name == 'Corso Gare' && end.name == 'Thénia Gare')
          LatLng(36.7300, 3.5000), // Example curve point
        if (start.name == 'Boumerdes Gare' && end.name == 'Tidjelabine Gare')
          LatLng(36.7500, 3.4850), // Example curve point
        end.location,
      ];
    }

    // For buses, use road routes
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
    // Load bus routes
    for (var busLine in busLines) {
      List<LatLng> fullRoute = [];
      for (int i = 0; i < busLine.stations.length - 1; i++) {
        final route = await getRouteBetweenStops(
          busLine.stations[i],
          busLine.stations[i + 1],
          isTrainRoute: false,
        );
        if (fullRoute.isEmpty) {
          fullRoute.addAll(route);
        } else {
          fullRoute.addAll(route.skip(1));
        }
      }
      busRoutes[busLine.name] = fullRoute;
    }

    // Load train routes
    for (var trainLine in trainLines) {
      List<LatLng> fullRoute = [];
      for (int i = 0; i < trainLine.stations.length - 1; i++) {
        final route = await getRouteBetweenStops(
          trainLine.stations[i],
          trainLine.stations[i + 1],
          isTrainRoute: true,
        );
        if (fullRoute.isEmpty) {
          fullRoute.addAll(route);
        } else {
          fullRoute.addAll(route.skip(1));
        }
      }
      busRoutes[trainLine.name] = fullRoute;
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
                builder: (context, child) {
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
          child: Row(
            children: [
              const Icon(Icons.schedule),
              const SizedBox(width: 16),
              const Text(
                'Transport Schedule',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Add toggle button
              IconButton(
                icon: Icon(
                  _showBusSchedule ? Icons.directions_bus : Icons.train,
                  color: _showBusSchedule ? Colors.blue : Colors.purple,
                ),
                onPressed: () {
                  setState(() {
                    _showBusSchedule = !_showBusSchedule;
                  });
                },
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
                // Show either bus or train schedules based on toggle
                if (_showBusSchedule)
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
                  ]
                else
                  for (var trainLine in trainLines) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.train, color: trainLine.color),
                          const SizedBox(width: 8),
                          Text(
                            trainLine.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: trainLine.color,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTrainStationTable(trainLine),
                    const SizedBox(height: 24),
                  ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Add this new method for train station tables
  Widget _buildTrainStationTable(TrainLine trainLine) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(4),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: trainLine.color.withOpacity(0.1),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Station',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: trainLine.color,
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
                      Icon(Icons.arrow_forward,
                          size: 18, color: trainLine.color),
                      const SizedBox(width: 8),
                      Text(
                        'Going',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: trainLine.color,
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
                          color: trainLine.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_back, size: 18, color: trainLine.color),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        for (var station in trainLine.stations)
          TableRow(
            decoration: const BoxDecoration(
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
                child: _buildTrainTimingRow(trainLine, station),
              ),
            ],
          ),
      ],
    );
  }

  // Simple train timing calculation
  String _getTrainTime(TrainLine trainLine, Station station, bool isForward) {
    bool isFirstStation = station.order == 1;
    bool isLastStation = station.order == trainLine.stations.length;

    if (isFirstStation || isLastStation) {
      int forwardTime =
          _calculateTrainTimeForDirection(trainLine, station, true);
      int reverseTime =
          _calculateTrainTimeForDirection(trainLine, station, false);

      int maxTime = max(forwardTime, reverseTime);
      return maxTime == 999999 ? '' : '$maxTime min';
    }

    return '${_calculateTrainTimeForDirection(trainLine, station, isForward)} min';
  }

  int _calculateTrainTimeForDirection(
      TrainLine trainLine, Station station, bool isForward) {
    int shortestTime = 999999;

    // Check each train in the line
    for (var train in trainLine.trains) {
      final controllerId = '${trainLine.name}_${train.id}';
      final controller = _animationControllers[controllerId];
      final animation = _animations[controllerId];

      if (controller == null || animation == null) continue;

      final totalDuration = trainLine.totalDuration;
      double timeToStation = 0;
      int stationIndex = trainLine.stations.indexOf(station);

      if (isForward) {
        // Calculate time to reach this station from start
        for (int i = 0; i < stationIndex; i++) {
          timeToStation += trainLine.stations[i].minutesToNextStation;
        }

        // If we've passed this station, add full route time
        if (animation.value * totalDuration > timeToStation) {
          timeToStation += totalDuration;
        }
      } else {
        // Calculate time from end to this station
        for (int i = trainLine.stations.length - 2; i >= stationIndex; i--) {
          timeToStation += trainLine.stations[i].minutesToNextStation;
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

  // Update the _buildTrainTimingRow method
  Widget _buildTrainTimingRow(TrainLine trainLine, Station station) {
    bool isFirstStation = station.order == 1;
    bool isLastStation = station.order == trainLine.stations.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Forward direction
        Expanded(
          child: Row(
            children: [
              Icon(Icons.arrow_forward, size: 14, color: trainLine.color),
              const SizedBox(width: 4),
              AnimatedBuilder(
                animation: Listenable.merge(
                  trainLine.trains
                      .where((train) => !train.id.contains('←'))
                      .map((train) => _animationControllers[
                          '${trainLine.name}_${train.id}'])
                      .whereType<AnimationController>()
                      .toList(),
                ),
                builder: (context, _) {
                  return Text(
                    _getTrainTime(trainLine, station, true),
                    style: TextStyle(
                      color: trainLine.color,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Return direction
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge(
                  trainLine.trains
                      .where((train) => train.id.contains('←'))
                      .map((train) => _animationControllers[
                          '${trainLine.name}_${train.id}'])
                      .whereType<AnimationController>()
                      .toList(),
                ),
                builder: (context, _) {
                  return Text(
                    _getTrainTime(trainLine, station, false),
                    style: TextStyle(
                      color: trainLine.color,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_back, size: 14, color: trainLine.color),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPoiToggleBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Transport toggles
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTransportToggle('Buses', Icons.directions_bus, 'buses'),
              _buildDivider(),
              _buildTransportToggle('Trains', Icons.train, 'trains'),
            ],
          ),
        ),
        // POI toggles
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPoiToggle('Mosques', Icons.mosque, 'mosques'),
              _buildDivider(),
              _buildPoiToggle('Toilets', Icons.wc, 'toilets'),
              _buildDivider(),
              _buildPoiToggle('Parking', Icons.local_parking, 'parking'),
              _buildDivider(),
              _buildPoiToggle('Food', Icons.restaurant, 'restaurants'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 1,
        height: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.withOpacity(0.1),
              Colors.grey.withOpacity(0.3),
              Colors.grey.withOpacity(0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoiToggle(String label, IconData icon, String type) {
    final isSelected = _poiToggles[type]!;
    final color = _poiColors[type]!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _poiToggles[type] = !_poiToggles[type]!;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportToggle(String label, IconData icon, String type) {
    final isSelected = _transportToggles[type]!;
    final color = _poiColors[type]!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _transportToggles[type] = !_transportToggles[type]!;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boumerdes Transport Lines'),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
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
                    // Animate bus markers if buses are toggled on
                    if (_transportToggles['buses']!)
                      for (var busLine in busLines)
                        if (busRoutes.containsKey(busLine.name))
                          for (var bus in busLine.buses)
                            if (_animations
                                .containsKey('${busLine.name}_${bus.id}'))
                              Marker(
                                point: _calculatePosition(
                                  busRoutes[busLine.name]!,
                                  _animations['${busLine.name}_${bus.id}']!
                                      .value,
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
                    // Add animated train markers if trains are toggled on
                    if (_transportToggles['trains']!)
                      for (var trainLine in trainLines)
                        if (busRoutes.containsKey(trainLine.name))
                          for (var train in trainLine.trains)
                            if (_animations
                                .containsKey('${trainLine.name}_${train.id}'))
                              Marker(
                                point: _calculatePosition(
                                  busRoutes[trainLine.name]!,
                                  _animations['${trainLine.name}_${train.id}']!
                                      .value,
                                  trainLine.name,
                                ),
                                width: 35, // Slightly larger than buses
                                height: 35,
                                child: RepaintBoundary(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: trainLine.color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.train,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            train.id.split(' ')[1],
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: trainLine.color,
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
                          // Bus routes if buses are toggled on
                          if (_transportToggles['buses']!)
                            for (var busLine in busLines)
                              if (busRoutes.containsKey(busLine.name))
                                Polyline(
                                  points: busRoutes[busLine.name]!,
                                  color: busLine.color,
                                  strokeWidth: 4.0,
                                  isDotted: true,
                                ),
                          // Train routes if trains are toggled on
                          if (_transportToggles['trains']!)
                            for (var trainLine in trainLines)
                              if (busRoutes.containsKey(trainLine.name))
                                Polyline(
                                  points: busRoutes[trainLine.name]!,
                                  color: trainLine.color,
                                  strokeWidth:
                                      5.0, // Slightly thicker for train routes
                                  isDotted: false, // Solid line for trains
                                ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          ...allMarkers,
                          // Add POI markers
                          ..._pois.where((poi) => _poiToggles[poi.type]!).map(
                                (poi) => Marker(
                                  point: poi.location,
                                  width: 40,
                                  height:
                                      60, // Increased height for better label visibility
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _poiColors[poi.type]!,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          poi.icon,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          poi.name,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: _poiColors[poi.type],
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
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
                  const Divider(height: 16),
                  ...trainLines.map((trainLine) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.train, color: trainLine.color, size: 24),
                            const SizedBox(width: 8),
                            Text(trainLine.name),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          // Move POI toggle bar from top to bottom
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Center(
              child: Transform.scale(
                scale: 0.85,
                child: _buildPoiToggleBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(LatLng point, String label, Color color,
      {bool isTrainStation = false}) {
    return Marker(
      point: point,
      width: 100,
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
              isTrainStation ? Icons.train : Icons.directions_bus,
              color: color,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
