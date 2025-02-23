import 'package:flutter/material.dart';

class MedicationRecordScreen extends StatefulWidget {
  const MedicationRecordScreen({Key? key}) : super(key: key);

  @override
  State<MedicationRecordScreen> createState() => _MedicationRecordScreenState();
}

class _MedicationRecordScreenState extends State<MedicationRecordScreen> {
  // 0: All, 1: Missed, 2: Used
  int selectedTab = 0;

  // Sample medication schedule items
  final List<Map<String, dynamic>> scheduleItems = [
    {
      "title": "Headach",
      "time": "dr akim",
      "status": "used", // used item
    },
    {
      "title": "Vitamin D exccess",
      "time": "dr max",
      "status": "missed", // missed item
    },
    {
      "title": "Insulin",
      "time": "dr gin",
      "status": "used",
    },
    {
      "title": "Take Blood Pressure Med",
      "time": "Dr tayo",
      "status": "missed",
    },
    {
      "title": "Multivitamin high",
      "time": "dr erik",
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
  final Color lightGreen = Color(0xffFEF2E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Medical record",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0E79B2),
      ),
      body: Column(
        children: [
          // You can add your top segmented control here if needed.
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
}

