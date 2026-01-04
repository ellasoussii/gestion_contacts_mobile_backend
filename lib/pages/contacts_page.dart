import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'add_contact_page.dart';
import 'edit_contact_page.dart';
import 'delete_contact_page.dart'; // si tu veux la confirmation

class ContactsPage extends StatefulWidget {
  final User user;
  const ContactsPage({super.key, required this.user});

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

  Future<void> _loadContacts() async {
    final data = await ApiService.getContacts(widget.user.id!);
    if (!mounted) return;
    setState(() => contacts = data);
  }

  Future<void> _delete(int id) async {
    final ok = await ApiService.deleteContact(id);
    if (ok) {
      _loadContacts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Suppression échouée")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts de ${widget.user.name}")),
      body: contacts.isEmpty
          ? const Center(child: Text("Aucun contact. Ajoutez-en !"))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (_, i) {
                final c = contacts[i];
                return ListTile(
                  title: Text("${c.name} ${c.surname ?? ""}"),
                  subtitle: Text("${c.phone}\n${c.birthdate ?? ""}"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditContactPage(contact: c)),
                          );
                          if (updated != null && updated is Contact) {
                            final ok = await ApiService.updateContact(updated);
                            if (ok) {
                              _loadContacts();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Mise à jour échouée")),
                              );
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DeleteContactPage(contact: c)),
                          );
                          if (confirm == true) {
                            _delete(c.id!);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactPage(userId: widget.user.id!)),
          );
          if (newContact != null && newContact is Contact) {
            setState(() => contacts.add(newContact));
          }
        },
      ),
    );
  }
}
