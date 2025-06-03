import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry_express/services/auth_service.dart';

class AkunEditPage extends StatefulWidget {
  const AkunEditPage({super.key});

  @override
  State<AkunEditPage> createState() => _AkunEditPageState();
}

class _AkunEditPageState extends State<AkunEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = FlutterSecureStorage();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();

  String? userId;
  String? token;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userId = await _storage.read(key: 'user_id');
    token = await _storage.read(key: 'access_token');

    if (userId != null && token != null) {
      final userData = await AuthService.getUser(userId!, token!);
      if (userData != null) {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
        });
      }
    }
  }

  void _submitEdit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text;
    final email = _emailController.text;
    final pass = _passwordController.text;

    if (userId != null && token != null) {
      final success = await AuthService.updateUser(userId!, name, email, pass, token!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil diubah')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengubah data')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Akun")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'Minimal 6 karakter',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEdit,
                child: const Text("Simpan Perubahan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
