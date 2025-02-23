import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'doctor_view.dart';
import '../../common_widget/round_button.dart';
import '../../common/color_extension.dart';

class RecordScreen extends StatefulWidget {
  final Map<String, dynamic> patient;
  final Function(Map<String, dynamic>) onUpdate;
  // Removed onDischarge as explicit discharge is no longer used
  const RecordScreen({
    Key? key,
    required this.patient,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late TextEditingController nameController;
  late TextEditingController idController;
  String? imagePath;
  List<String> doctors = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.patient["name"] ?? "");
    idController = TextEditingController(text: widget.patient["id"] ?? "");
    imagePath = widget.patient["image"];
    doctors = List<String>.from(widget.patient["doctors"] ?? []);
  }

  // Helper function to auto-save changes.
  void _autoSave() {
    widget.onUpdate({
      "name": nameController.text,
      "id": idController.text,
      "image": imagePath,
      "doctors": doctors,
    });
  }

  // **Pick Image Function** — after picking an image, auto-save.
  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Take Photo"),
              onTap: () async {
                final XFile? pickedFile =
                await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    imagePath = pickedFile.path;
                  });
                  _autoSave();
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                final XFile? pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    imagePath = pickedFile.path;
                  });
                  _autoSave();
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // **Edit Name & ID** — opens a dialog to edit a field and auto-saves upon confirmation.
  void editField(TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Information"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter new value"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                _autoSave();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // **Add New Doctor** — after adding a doctor, auto-save.
  Future<void> addDoctor() async {
    final String? newDoctor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDoctorScreen()),
    );
    if (newDoctor != null && newDoctor.isNotEmpty) {
      setState(() {
        doctors.add(newDoctor);
      });
      _autoSave();
    }
  }

  // **Delete Doctor with Swipe Effect** — auto-save after deletion.
  void deleteDoctor(int index) {
    setState(() {
      doctors.removeAt(index);
    });
    _autoSave();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Doctor removed"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white, // Applying theme color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // **Profile Section with "Add Doctor" Button**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  "Patient",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 28, color: TColor.primary),
                  onPressed: addDoctor,
                ),
              ],
            ),
            // **Patient Image & Picker**
            const SizedBox(height: 2),
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: TColor.placeholder,
                child: imagePath == null || imagePath!.isEmpty
                    ? Icon(Icons.person, size: 50, color: TColor.secondaryText)
                    : ClipOval(
                  child: Image.file(
                    File(imagePath!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // **Patient Name & ID – Editable with auto-save**
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nameController.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColor.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 18, color: TColor.primary),
                      onPressed: () => editField(nameController),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Patient ID: ${idController.text}",
                      style: TextStyle(fontSize: 16, color: TColor.secondaryText),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 18, color: TColor.primary),
                      onPressed: () => editField(idController),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // **Centered Treatment Title with Shadow**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColor.primary.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  "Treatment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // **Swipe-to-Delete Effect for Doctors**
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(doctors[index]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteDoctor(index);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      color: TColor.white,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.local_hospital, color: TColor.primary),
                        title: Text(
                          doctors[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Removed the explicit "Save Changes" and "Discharge" buttons.
          ],
        ),
      ),
    );
  }
}
