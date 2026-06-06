import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; 
import 'air_quality_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  DocumentSnapshot? selectedZone;

  Color getAqiColor(double aqi) {
    if (aqi > 100) return Colors.redAccent;
    if (aqi > 50) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('AQI_ZONE').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Marker> markers = [];

            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              double aqi = (data['AQI_VALUE'] ?? 0).toDouble();
              Color statusColor = getAqiColor(aqi);

              markers.add(
                Marker(
                  point: LatLng(data['LATITUDE'], data['LONGITUDE']),
                  width: 45,
                  height: 45,
                  child: GestureDetector(
                    onTap: () => setState(() => selectedZone = doc),
                    child: Container(
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          aqi.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(25.2048, 55.2708),
                    initialZoom: 10.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.air_sense',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
                if (selectedZone != null)
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: AirQualityCard(data: selectedZone!),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}