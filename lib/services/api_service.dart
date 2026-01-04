import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/contact.dart';

class ApiService {
  // Android émulateur: 10.0.2.2
  static const String baseUrl = "http://10.0.2.2:8000";

  // LOGIN
  static Future<User?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  // SIGNUP
  static Future<User?> signup(User user) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return User.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  // GET CONTACTS
  static Future<List<Contact>> getContacts(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/contacts/$userId"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Contact.fromJson(e)).toList();
    }
    return [];
  }

  // ADD CONTACT
  static Future<Contact?> addContact(Contact contact) async {
    final res = await http.post(
      Uri.parse("$baseUrl/contacts"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contact.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Contact.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  // UPDATE CONTACT
  static Future<bool> updateContact(Contact contact) async {
    final res = await http.put(
      Uri.parse("$baseUrl/contacts/${contact.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contact.toJson()),
    );
    return res.statusCode == 200;
  }

  // DELETE CONTACT
  static Future<bool> deleteContact(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/contacts/$id"));
    return res.statusCode == 200;
  }
}
