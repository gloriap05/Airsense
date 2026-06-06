import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AirQualityCard extends StatelessWidget {
  final DocumentSnapshot data;
  const AirQualityCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 1. Data Retrieval
    final Map<String, dynamic> docData = data.data() as Map<String, dynamic>;
    double aqi = (docData['AQI_VALUE'] ?? 0).toDouble();
    String risk = docData['RISK_LEVEL'] ?? 'N/A';
    // Retrieve the new zone name field
    String zoneName = docData['ZONE_NAME'] ?? 'Unknown Location';

    // 2. Dynamic Colors
    Color statusColor = aqi > 100 ? Colors.redAccent : (aqi > 50 ? Colors.orangeAccent : Colors.greenAccent);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Displaying the Zone Name
              Text(
                zoneName,
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w600, 
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "AQI ${aqi.toInt()}",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  risk.toUpperCase(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}