import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class DrugManagementScreen extends StatefulWidget {
  final List<Map<String, dynamic>> drugRecords;

  const DrugManagementScreen({super.key, required this.drugRecords});

  @override
  State<DrugManagementScreen> createState() => _DrugManagementScreenState();
}

class _DrugManagementScreenState extends State<DrugManagementScreen> {
  List<Map<String, dynamic>> filteredRecords = [];
  TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRecords = List.from(widget.drugRecords);
  }

  // **Search for a Prescription**
  void searchRecords(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecords = List.from(widget.drugRecords);
      } else {
        filteredRecords = widget.drugRecords
            .where((record) => record["recordTitle"]
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // **Delete Prescription Permanently**
  void deleteRecord(int index) {
    setState(() {
      filteredRecords.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Prescription deleted permanently"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // **Set Frequency for Drug Intake and Send Notification Reminder**
  void setFrequency(Map<String, dynamic> record) {
    TextEditingController freqController = TextEditingController();
    if (record.containsKey("frequency")) {
      freqController.text = record["frequency"].toString();
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Drug Intake Frequency"),
          content: TextField(
            controller: freqController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Frequency (in hours)",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (freqController.text.isNotEmpty) {
                  setState(() {
                    record["frequency"] = freqController.text;
                  });
                  Navigator.pop(context);
                  // Simulate sending a notification reminder to the notification screen.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Reminder set: take your drug every ${freqController.text} hours"),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  // TODO: Integrate with your notification system here.
                }
              },
              child: const Text("Set"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        title: const Text(
          "Drug Management",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // **Search Bar**
            RoundTextfield(
              hintText: "Search Prescriptions",
              controller: txtSearch,
              onChanged: searchRecords,
              left: Container(
                alignment: Alignment.center,
                width: 30,
                child: Icon(Icons.search, color: TColor.primary),
              ),
            ),
            const SizedBox(height: 10),
            // **Prescription List**
            Expanded(
              child: filteredRecords.isEmpty
                  ? const Center(
                child: Text(
                  "No prescriptions available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  var record = filteredRecords[index];
                  return Card(
                    color: TColor.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: TColor.placeholder,
                        child: const Icon(
                          Icons.medication,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        record["recordTitle"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryText),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Record ID: ${record["recordID"]}",
                            style: TextStyle(
                                color: TColor.secondaryText),
                          ),
                          if (record.containsKey("frequency"))
                            Text(
                              "Frequency: every ${record["frequency"]} hours",
                              style: TextStyle(
                                  color: TColor.secondaryText),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.alarm, color: TColor.primary),
                            onPressed: () => setFrequency(record),
                          ),
                          IconButton(
                            icon:
                            const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteRecord(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
