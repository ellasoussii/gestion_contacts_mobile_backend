import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/contact.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  // LOGIN
  static Future<User?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  // SIGNUP
  static Future<bool> signup(User user) async {
    final res = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    return res.statusCode == 201;
  }

  // GET CONTACTS
  static Future<List<Contact>> getContacts(int userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/contacts/$userId"),
    );

    final List data = jsonDecode(res.body);
    return data.map((e) => Contact.fromJson(e)).toList();
  }

  // ADD CONTACT
  static Future<void> addContact(Contact contact) async {
    await http.post(
      Uri.parse("$baseUrl/contacts"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contact.toJson()),
    );
  }

  // UPDATE CONTACT
  static Future<void> updateContact(Contact contact) async {
    await http.put(
      Uri.parse("$baseUrl/contacts/${contact.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contact.toJson()),
    );
  }

  // DELETE CONTACT
  static Future<void> deleteContact(int id) async {
    await http.delete(
      Uri.parse("$baseUrl/contacts/$id"),
    );
  }
}
