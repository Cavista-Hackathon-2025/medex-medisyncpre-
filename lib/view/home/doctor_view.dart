import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController doctorNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Doctor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: doctorNameController,
              decoration: const InputDecoration(labelText: "Doctor Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (doctorNameController.text.isNotEmpty) {
                  Navigator.pop(context, doctorNameController.text);
                }
              },
              child: const Text("Add Doctor"),
            ),
          ],
        ),
      ),
    );
  }
}
