import 'package:flutter/material.dart';

class MedicationScheduleScreen extends StatefulWidget {
  const MedicationScheduleScreen({Key? key}) : super(key: key);

  @override
  State<MedicationScheduleScreen> createState() => _MedicationScheduleScreenState();
}

class _MedicationScheduleScreenState extends State<MedicationScheduleScreen> {
  // 0: All, 1: Missed, 2: Used
  int selectedTab = 0;

  // Sample medication schedule items
  final List<Map<String, dynamic>> scheduleItems = [
    {
      "title": "Take Aspirin",
      "time": "08:00 AM",
      "status": "used", // used item
    },
    {
      "title": "Take Vitamin D",
      "time": "12:00 PM",
      "status": "missed", // missed item
    },
    {
      "title": "Take Insulin",
      "time": "06:00 PM",
      "status": "used",
    },
    {
      "title": "Take Blood Pressure Med",
      "time": "10:00 PM",
      "status": "missed",
    },
    {
      "title": "Take Multivitamin",
      "time": "07:00 AM",
      "status": "used",
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    if (selectedTab == 0) {
      return scheduleItems;
    } else if (selectedTab == 1) {
      return scheduleItems.where((item) => item["status"] == "missed").toList();
    } else if (selectedTab == 2) {
      return scheduleItems.where((item) => item["status"] == "used").toList();
    }
    return scheduleItems;
  }

  // Colors for statuses
  final Color lightRed = Color(0xffFEF2E7);
  final Color lightGreen = Colors.greenAccent.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medication Schedule",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff0E79B2),
      ),

      body: Column(
        children: [
          // Top segmented control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSegment("All", 0),
                _buildSegment("Missed", 1),
                _buildSegment("Used", 2),
              ],
            ),
          ),
          const Divider(height: 1),
          // List of schedule cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                Color? cardColor;
                if (item["status"] == "missed") {
                  cardColor = lightRed;
                } else if (item["status"] == "used") {
                  cardColor = lightGreen;
                } else {
                  cardColor = Colors.white;
                }
                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      item["title"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item["time"]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(String title, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xff0E79B2) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          // Underline indicator for selected segment.
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isSelected ? 30 : 0,
            color: isSelected ? Color(0xff0E79B2) : Colors.transparent,
          )
        ],
      ),
    );
  }
}
