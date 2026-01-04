import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/contact.dart';
import '../services/api_service.dart';

class AddContactPage extends StatefulWidget {
  final int userId;
  const AddContactPage({super.key, required this.userId});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();

  String? birthdate;
  File? imageFile;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        birthdate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  void _save() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nom et téléphone sont obligatoires !"), backgroundColor: Colors.red),
      );
      return;
    }

    final contact = Contact(
      userId: widget.userId,
      name: name,
      surname: surnameController.text.trim().isEmpty ? null : surnameController.text.trim(),
      phone: phone,
      birthdate: birthdate,
      photo: imageFile?.path,
    );

    final created = await ApiService.addContact(contact);

    if (!mounted) return;

    Navigator.pop(context, created);
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                  child: imageFile == null ? const Icon(Icons.camera_alt, size: 35) : null,
                ),
              ),
              const SizedBox(height: 20),

              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
              const SizedBox(height: 12),
              TextField(controller: surnameController, decoration: const InputDecoration(labelText: "Prénom")),
              const SizedBox(height: 12),
              TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Téléphone")),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(birthdate == null ? "Date de naissance" : "Date : $birthdate"),
                  ),
                  ElevatedButton(onPressed: pickDate, child: const Text("Choisir")),
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton(onPressed: _save, child: const Text("Ajouter le contact")),
            ],
          ),
        ),
      ),
    );
  }
}
