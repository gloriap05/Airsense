import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'signin_page.dart';
import 'screens/home_tab.dart';
import 'map_screen.dart';
import 'screens/alerts_tab.dart';
import 'screens/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final ValueNotifier<Position?> _positionNotifier = ValueNotifier(null);
  StreamSubscription<Position>? _positionStream;

  String? _lastZone;
  Map<String, dynamic>? _lastStableDoc;

  @override
  void initState() {
    super.initState();
    _startLocationStream();
  }

  void _startLocationStream() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    ).listen((position) {
      _positionNotifier.value = position;
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _positionNotifier.dispose();
    super.dispose();
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2E5A),
          title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                  (route) => false,
                );
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Map<String, double> _generatePM(double aqi) {
    return {
      "PM10": aqi * 0.6,
      "PM25": aqi * 0.4,
      "PM1": aqi * 0.2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Position?>(
        valueListenable: _positionNotifier,
        builder: (context, currentPosition, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('AQI_ZONE')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var docs = snapshot.data!.docs;

              Map<String, dynamic>? nearestDoc;

              if (currentPosition != null) {
                double minDistance = double.infinity;
                Map<String, dynamic>? candidate;

                for (var doc in docs) {
                  var data = doc.data() as Map<String, dynamic>;

                  double lat = _safeDouble(data['LATITUDE']);
                  double lng = _safeDouble(data['LONGITUDE']);

                  double dist = Geolocator.distanceBetween(
                    currentPosition.latitude,
                    currentPosition.longitude,
                    lat,
                    lng,
                  );

                  if (dist < minDistance) {
                    minDistance = dist;
                    candidate = data;
                  }
                }

                if (candidate != null) {
                  String newZone = candidate['ZONE_NAME'];

                  if (_lastZone == null || _lastZone != newZone) {
                    _lastZone = newZone;
                    _lastStableDoc = candidate;
                    nearestDoc = candidate;
                  } else {
                    nearestDoc = _lastStableDoc;
                  }
                }
              }

              nearestDoc ??=
                  _lastStableDoc ??
                  (docs.isNotEmpty
                      ? docs.first.data() as Map<String, dynamic>
                      : {});

              final aqi = _safeDouble(nearestDoc['AQI_VALUE']);
              final pm = _generatePM(aqi);

              return IndexedStack(
                index: currentIndex,
                children: [
                  HomeTab(
                    activeLocationName:
                        nearestDoc['ZONE_NAME'] ?? "Unknown",

                    activeCAQI: aqi.toInt(),

                    airQualityStatusText:
                        "Live AQI near ${nearestDoc['ZONE_NAME'] ?? 'your location'}",

                    pm10Value: pm["PM10"]!,
                    pm25Value: pm["PM25"]!,
                    pm1Value: pm["PM1"]!,

                    regionForecastAQI: docs.map((d) {
                      var m = d.data() as Map<String, dynamic>;
                      return {
                        'name': m['ZONE_NAME'],
                        'value': _safeDouble(m['AQI_VALUE']),
                      };
                    }).toList(),

                    onBackArrowPressed: _showSignOutDialog,
                    onMapArrowPressed: () =>
                        setState(() => currentIndex = 1),
                    onMenuTabSelected: (index) =>
                        setState(() => currentIndex = index),
                  ),
                  const MapScreen(),
                  const AlertsTab(),
                  const ProfileTab(),
                ],
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: "Alerts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}