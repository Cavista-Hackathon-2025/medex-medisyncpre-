import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../about/notification_view.dart';
import '../drugmangement/drugmanagement_view.dart';
import 'record_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> medRecords = [];
  int unreadNotifications = 5;

  @override
  void initState() {
    super.initState();
    loadMedRecords();
  }

  // **Load Medical Records from Storage**
  Future<void> loadMedRecords() async {
    // Your storage load implementation here...
  }

  // **Add New Medical Record**
  void addNewRecord() {
    TextEditingController titleController = TextEditingController();
    TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Medical Record"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Record Title"),
              ),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Record ID"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && idController.text.isNotEmpty) {
                  setState(() {
                    medRecords.add({
                      "recordTitle": titleController.text,
                      "recordID": idController.text,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // **Dashboard Section**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    // **App Logo (With OnTap Functionality)**
                    GestureDetector(
                      onTap: () => print("App Logo Tapped!"),
                      child: Image.asset(
                        "assets/img/app_logo.png", // Replace with your actual asset
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // **Welcome Message**
                    const Expanded(
                      child: Text(
                        "Welcome, Nuru",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // **Notification & Dosage Message Section**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              unreadNotifications = 0;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationsView()),
                            );
                          },
                          icon: const Icon(Icons.notifications, size: 28, color: Colors.blue),
                        ),
                        if (unreadNotifications > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadNotifications.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Text(
                      "Afternoon Dosage: 1 Pill Left",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsView()));
                      },
                      child: const Text("See Details", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // **Fitness for You Section**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "Fitness for You",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140, // Card Image Height
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFitnessCard("assets/img/fitness1.png"),
                _buildFitnessCard("assets/img/fitness2.png"),
                _buildFitnessCard("assets/img/fitness3.png"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // **Medical Record Section**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Medical Record",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View All", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // **Medical Records List**
          Expanded(
            child: medRecords.isEmpty
                ? const Center(child: Text("No records found."))
                : ListView.builder(
              itemCount: medRecords.length,
              itemBuilder: (context, index) {
                var record = medRecords[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListTile(
                    title: Text(record["recordTitle"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Record ID: ${record["recordID"]}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordScreen(
                              patient: record, // Pass the record data
                              onUpdate: (updatedRecord) {
                                setState(() {
                                  medRecords[index] = updatedRecord;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating action button navigates to Drug Management Screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DrugManagementScreen(
          //       drugRecords: drugRecords,
          //     ),
          //   ),
          // );
        },
        backgroundColor: TColor.primary,
        child: const Icon(Icons.medication_rounded),
      ),
    );
  }

  // **Build Fitness Cards**
  Widget _buildFitnessCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            imagePath,
            width: 140,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


