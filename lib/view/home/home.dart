import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
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
  List<Map<String, dynamic>> filteredRecords = [];
  List<Map<String, dynamic>> drugRecords = [];
  TextEditingController txtSearch = TextEditingController();
  int unreadNotifications = 5;
  Map<String, dynamic>? lastDeletedRecord;
  int lastDeletedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadMedRecords();
    loadDrugRecords();
  }

  // **Load Medical Records from Storage**
  Future<void> loadMedRecords() async {
    // Your load implementation here...
  }

  // **Load Drug Management Records from Storage**
  Future<void> loadDrugRecords() async {
    // Your load implementation here...
  }

  // **Save Medical Records to Storage**
  Future<void> saveMedRecords() async {
    // Your save implementation here...
  }

  // **Save Drug Management Records to Storage**
  Future<void> saveDrugRecords() async {
    // Your save implementation here...
  }

  // **Update Medical Record Details**
  void updateRecord(Map<String, dynamic> updatedRecord) {
    int index = medRecords.indexWhere(
            (r) => r["recordID"].toString() == updatedRecord["recordID"].toString());
    if (index != -1) {
      setState(() {
        medRecords[index] = updatedRecord;
        filteredRecords = List.from(medRecords);
        saveMedRecords();
      });
    }
  }

  // **Search for a Medical Record**
  void searchRecords(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecords = List.from(medRecords);
      } else {
        filteredRecords = medRecords
            .where((record) => record["recordTitle"]
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    idController.text.isNotEmpty) {
                  setState(() {
                    medRecords.add({
                      "recordTitle": titleController.text,
                      "image": null,
                      "recordID": idController.text,
                    });
                    filteredRecords = List.from(medRecords);
                    saveMedRecords();
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

  // **Return Prescription from Drug Management to Home**
  void returnPrescriptionToHome(Map<String, dynamic> record) {
    setState(() {
      drugRecords.removeWhere(
              (r) => r["recordID"].toString() == record["recordID"].toString());
      medRecords.add(record);
      saveMedRecords();
      saveDrugRecords();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Prescription record returned to Home"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // **Accept Prescription (Drug Management)**
  void acceptPrescription(Map<String, dynamic> record) {
    setState(() {
      medRecords.removeWhere(
              (r) => r["recordID"].toString() == record["recordID"].toString());
      drugRecords.add(record);
      filteredRecords = List.from(medRecords);
      saveMedRecords();
      saveDrugRecords();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Prescription accepted"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // **Slide-to-Delete Record**
  void deleteRecord(int index) {
    int realIndex = medRecords.indexWhere((r) =>
    r["recordID"].toString() ==
        filteredRecords[index]["recordID"].toString());

    if (realIndex != -1) {
      setState(() {
        lastDeletedRecord = Map.from(medRecords[realIndex]);
        lastDeletedIndex = realIndex;

        medRecords.removeAt(realIndex);
        filteredRecords = List.from(medRecords);
        saveMedRecords();
      });

      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Record deleted"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          action: SnackBarAction(
            label: "Undo",
            onPressed: undoDeleteRecord,
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // **Undo Delete**
  void undoDeleteRecord() {
    if (lastDeletedRecord != null && lastDeletedIndex != -1) {
      setState(() {
        medRecords.insert(lastDeletedIndex, lastDeletedRecord!);
        filteredRecords = List.from(medRecords);
        saveMedRecords();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with add button, notifications and search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: addNewRecord,
                      icon: Icon(Icons.add, size: 28, color: TColor.primary),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              unreadNotifications = 0;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const NotificationsView(),
                              ),
                            );
                          },
                          icon: Icon(Icons.notifications,
                              size: 28, color: TColor.primary),
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
                  ],
                ),
                const SizedBox(height: 10),
                RoundTextfield(
                  hintText: "Search Medical Records",
                  controller: txtSearch,
                  onChanged: searchRecords,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Icon(Icons.search, color: TColor.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // List of received medical records shown under the search bar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                var record = filteredRecords[index];
                return Dismissible(
                  key: Key(record["recordID"].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deleteRecord(index);
                  },
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(record["recordTitle"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Record ID: ${record["recordID"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecordScreen(
                                patient: record, // Pass the current record
                                onUpdate: updateRecord, // Use updateRecord method
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating action button now navigates to the DrugManagementScreen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrugManagementScreen(
                drugRecords: drugRecords,
              ),
            ),
          );
        },
        backgroundColor: TColor.primary,
        child: const Icon(Icons.medication_rounded),
      ),
    );
  }
}
