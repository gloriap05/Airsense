import 'package:flutter/material.dart';
import 'new_report_screen.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),

      // ===== FLOATING BUTTON =====
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewReportScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded, size: 26),
          label: const Text(
            "New Report",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),

      body: Stack(
        children: [

          // ===== BACKGROUND BLOBS =====
          Positioned(
            top: -90,
            right: -50,
            child: _blob(240),
          ),
          Positioned(
            top: 280,
            left: -70,
            child: _blob(190),
          ),
          Positioned(
            bottom: -50,
            right: -40,
            child: _blob(170),
          ),

          // ===== CONTENT =====
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [

                // ===== HEADER =====
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AirSense Alerts",
                            style: TextStyle(
                              fontSize: 31,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF102A43),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Live AQI updates, community reports & alerts",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ===== CLICKABLE NOTIFICATION ICON =====
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (_) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Notifications",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  _FakeNotification(
                                    title: "Air Quality Alert",
                                    subtitle: "AQI is moderate in your area",
                                    icon: Icons.air,
                                    color: Colors.orange,
                                  ),

                                  _FakeNotification(
                                    title: "New Report Verified",
                                    subtitle: "A community report was approved",
                                    icon: Icons.check_circle,
                                    color: Colors.green,
                                  ),

                                  _FakeNotification(
                                    title: "System Update",
                                    subtitle: "AirSense running normally",
                                    icon: Icons.system_update,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFF3B82F6),
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ===== AQI CARD =====
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF60A5FA),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Air Quality Alert",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "AQI levels are elevated in some areas. Reduce outdoor exposure if sensitive.",
                        style: TextStyle(color: Colors.white, height: 1.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Live Community Feed",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF102A43),
                  ),
                ),

                const SizedBox(height: 16),

                _reportCard(
                  icon: Icons.local_fire_department_rounded,
                  title: "Smoke Detected",
                  subtitle: "Strong smell of smoke in area.",
                  status: "Verified",
                  time: "2 mins ago",
                  color: Colors.redAccent,
                ),

                _reportCard(
                  icon: Icons.air_rounded,
                  title: "Dust & Haze",
                  subtitle: "Reduced visibility due to haze.",
                  status: "Pending",
                  time: "10 mins ago",
                  color: Colors.orange,
                ),

                _reportCard(
                  icon: Icons.construction_rounded,
                  title: "Construction Dust",
                  subtitle: "Dust affecting pedestrians.",
                  status: "Verified",
                  time: "18 mins ago",
                  color: Colors.blue,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== BACKGROUND BLOBS =====
  static Widget _blob(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(0.08),
      ),
    );
  }

  // ===== REPORT CARD =====
  static Widget _reportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle),
                Text(time),
              ],
            ),
          ),
          Text(status, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

// ===== FAKE NOTIFICATION WIDGET =====
class _FakeNotification extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _FakeNotification({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}