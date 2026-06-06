import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeTab extends StatelessWidget {
  final String activeLocationName;
  final int activeCAQI;
  final String airQualityStatusText;
  final double pm10Value;
  final double pm25Value;
  final double pm1Value;
  final List<Map<String, dynamic>> regionForecastAQI;
  final VoidCallback onBackArrowPressed;
  final VoidCallback onMapArrowPressed;
  final ValueChanged<int> onMenuTabSelected;

  const HomeTab({
    super.key,
    required this.activeLocationName,
    required this.activeCAQI,
    required this.airQualityStatusText,
    required this.pm10Value,
    required this.pm25Value,
    required this.pm1Value,
    required this.regionForecastAQI,
    required this.onBackArrowPressed,
    required this.onMapArrowPressed,
    required this.onMenuTabSelected,
  });

  // Helper method to explicitly force white icons and white text on the dark navy background
  PopupMenuItem<int> _buildPopupItem(int value, IconData icon, String title) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Text(
            title, 
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF1E224F);       
    const bgIceBlue = Color(0xFFE0F2FE);         
    const cardLightBlue = Color(0xFFC0E4FC);     
    const forecastCardDark = Color(0xFF1A2E5A);  

    double maximumYValue = 200;
    for (var area in regionForecastAQI) {
      if (area['value'] > maximumYValue) {
        maximumYValue = area['value'] + 30;
      }
    }

    return Scaffold(
      backgroundColor: bgIceBlue,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Action Navigation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
  onTap: onBackArrowPressed,
  child: Container(
    width: 44,
    height: 44,
    decoration: const BoxDecoration(
      color: Colors.white, // Keeps the white circle background
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0), // Adds space around the logo
      child: Image.asset(
        'assets/logoc.jpeg', // Loads your specific image
        fit: BoxFit.contain,
      ),
    ),
  ),
),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _buildRoundButton(Icons.home_filled, primaryNavy, Colors.white, size: 36),
                        const SizedBox(width: 12),
                        Text(
                          activeLocationName, 
                          style: const TextStyle(color: primaryNavy, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  
                  // Interactive Dropdown Pages Navigation Menu
                  Theme(
                    data: Theme.of(context).copyWith(
                      cardColor: forecastCardDark, // Deep navy background fallback
                    ),
                    child: PopupMenuButton<int>(
                      onSelected: onMenuTabSelected,
                      color: forecastCardDark, // Explicit container background overrides
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      icon: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(color: primaryNavy, shape: BoxShape.circle),
                        child: const Icon(Icons.apps, color: Colors.white, size: 44 * 0.45),
                      ),
                      itemBuilder: (context) => [
                        _buildPopupItem(0, Icons.home, "Home Dashboard"),
                        _buildPopupItem(1, Icons.map, "Air Quality Map"),
                        _buildPopupItem(2, Icons.notifications, "Alerts Feed"),
                        _buildPopupItem(3, Icons.person, "User Profile"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Main Hero Panel Display
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 11,
                    child: Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF38BDF8), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                          topRight: Radius.circular(140),
                          bottomRight: Radius.circular(140),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                          topRight: Radius.circular(140),
                          bottomRight: Radius.circular(140),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Opacity(
                                opacity: 0.15,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$activeCAQI", 
                                    style: const TextStyle(
                                      fontSize: 68,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 14.0),
                                    child: Text(
                                      "AQI", 
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.thumb_up_alt_outlined, color: primaryNavy, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          airQualityStatusText, 
                          style: const TextStyle(
                            color: primaryNavy,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // 3. Middle Segment Cards: Pollutants Breakdown
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildPollutantCard("PM10", pm10Value.toStringAsFixed(0), primaryNavy, cardLightBlue),
                    _buildPollutantCard("PM2.5", pm25Value.toStringAsFixed(0), primaryNavy, cardLightBlue),
                    _buildPollutantCard("PM1", pm1Value.toStringAsFixed(0), primaryNavy, cardLightBlue),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Lower Section: Live Firebase Collection Bar Graph Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: forecastCardDark,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "LIVE CITY AQI LEVELS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: onMapArrowPressed, 
                          child: _buildRoundButton(Icons.north_east, Colors.white.withOpacity(0.2), Colors.white, size: 36),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200, 
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maximumYValue, 
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60, 
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < regionForecastAQI.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: RotatedBox(
                                        quarterTurns: 3, 
                                        child: Text(
                                          regionForecastAQI[index]['name'], 
                                          style: const TextStyle(
                                            color: Colors.white70, 
                                            fontSize: 10, 
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value % 50 == 0) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(color: Colors.white38, fontSize: 9),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withOpacity(0.08),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(regionForecastAQI.length, (index) {
                            final double currentVal = regionForecastAQI[index]['value'];
                            
                            Color barThemeColor = const Color(0xFF22C55E); 
                            if (currentVal > 150) {
                              barThemeColor = const Color(0xFFEF4444); 
                            } else if (currentVal > 100) {
                              barThemeColor = const Color(0xFFF97316); 
                            } else if (currentVal > 50) {
                              barThemeColor = const Color(0xFFEAB308); 
                            }
                            
                            return _makeForecastBar(index, currentVal, barThemeColor);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, Color bg, Color iconColor, {double size = 44}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: size * 0.45),
    );
  }

  Widget _buildPollutantCard(String label, String value, Color mainColor, Color bg) {
    return Container(
      width: 135,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.15,
              child: Icon(Icons.blur_on, size: 32, color: mainColor),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: mainColor.withOpacity(0.7), fontSize: 14)),
                  Icon(Icons.north_east, size: 16, color: mainColor.withOpacity(0.5)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: mainColor)),
                  const SizedBox(width: 4),
                  Text("µg/m³", style: TextStyle(fontSize: 11, color: mainColor.withOpacity(0.6), fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeForecastBar(int x, double y, Color barColor) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 14, 
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}