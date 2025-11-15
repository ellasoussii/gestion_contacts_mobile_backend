import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/contact.dart';
import 'add_contact_page.dart';
import 'edit_contact_page.dart';
import 'delete_contact_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    final data = await DatabaseHelper.instance.getContacts();
    setState(() => contacts = data);
  }

  void _addContact(Contact contact) async {
    await DatabaseHelper.instance.addContact(contact);
    _loadContacts();
  }

  void _editContact(Contact contact) async {
    await DatabaseHelper.instance.updateContact(contact);
    _loadContacts();
  }

  void _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des contacts')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditContactPage(contact: contact),
                      ),
                    );
                    if (updated != null) _editContact(updated);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeleteContactPage(contact: contact),
                      ),
                    );
                    if (confirm == true) _deleteContact(contact.id!);
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
