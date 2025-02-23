import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
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

  // **Add New Patient**
  void addNewPatient() {
    TextEditingController nameController = TextEditingController();
    TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Patient"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Patient Name"),
              ),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Patient ID"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && idController.text.isNotEmpty) {
                  setState(() {
                    medRecords.add({
                      "recordTitle": nameController.text,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // **App Logo at the Top Left with Reduced Space**
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20,),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: addNewPatient,
                  child: Image.asset(
                    "assets/img/app_logo.png", // Replace with your actual asset
                    width: 160,
                    height: 60,
                  ),
                ),
              ),
            ),

            // **Dashboard Section**
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffD0ECFB), // Primary color background
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30), // Ensuring circular top edges
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        "Welcome, Nuru",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                            icon: const Icon(Icons.notifications, size: 28, color: Color(0xff0E79B2)),
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
                        "Afternoon Dosage",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffF39237)),
                      ),
                      RoundButton(
                        title: "See Details",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsView()),
                          );
                        },
                        type: RoundButtonType.bgPrimary,
                        fontSize: 12, // Reduced text size
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // **Fitness & Medical Records Wrapped in ScrollView**
            SingleChildScrollView(
              child: Column(
                children: [
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
                        _buildFitnessCard("assets/img/fitness.png"),
                        _buildFitnessCard("assets/img/fitness.png"),
                        _buildFitnessCard("assets/img/fitness.png"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

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
                  SizedBox(
                    height: 250, // Set a max height for proper scrolling
                    child: medRecords.isEmpty
                        ? const Center(child: Text("No records found."))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                      patient: record,
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
            ),
          ],
        ),
      ),

      // Floating action button navigates to Drug Management Screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
          child: Image.asset(imagePath, width: 140, height: 120, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

