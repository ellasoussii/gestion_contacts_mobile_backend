import 'package:flutter/material.dart';
import 'add_contact_page.dart';
import 'edit_contact_page.dart';
import 'delete_contact_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Map<String, String>> contacts = [];

  void _addContact(Map<String, String> contact) {
    setState(() => contacts.add(contact));
  }

  void _editContact(int index, Map<String, String> updated) {
    setState(() => contacts[index] = updated);
  }

  void _deleteContact(int index) {
    setState(() => contacts.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des contacts')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index]['name'] ?? ''),
            subtitle: Text(contacts[index]['phone'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditContactPage(contact: contacts[index]),
                      ),
                    );
                    if (updated != null) _editContact(index, updated);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeleteContactPage(contact: contacts[index]),
                      ),
                    );
                    if (confirm == true) _deleteContact(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactPage()),
          );
          if (newContact != null) _addContact(newContact);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
