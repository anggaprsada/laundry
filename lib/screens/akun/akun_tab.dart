import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry_express/screens/akun/akun_edit.dart';
import 'package:laundry_express/screens/login_screen.dart';
import 'package:laundry_express/services/auth_service.dart';

class AkunTab extends StatefulWidget {
  const AkunTab({super.key});

  @override
  State<AkunTab> createState() => _AkunTabState();
}

class _AkunTabState extends State<AkunTab> {
  final storage = const FlutterSecureStorage();

  String name = '';
  String email = '';
  String userId = '';
  String token = '';

  bool isLoading = true; // untuk menampilkan loading indikator
  bool hasError = false; // jika gagal load data user

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final storedToken = await storage.read(key: 'access_token');
      final storedUserId = await storage.read(key: 'user_id');

      print('DEBUG: storedToken = $storedToken');
      print('DEBUG: storedUserId = $storedUserId');

      if (storedToken != null && storedUserId != null) {
        final user = await AuthService.getUser(storedUserId, storedToken);

        print('DEBUG: user from API = $user');

        if (user != null) {
          setState(() {
            token = storedToken;
            userId = storedUserId;
            name = user['name'] ?? '';
            email = user['email'] ?? '';
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error load user data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void logout(BuildContext context) async {
    await storage.deleteAll(); // bersihkan semua data login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  void deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus akun ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await AuthService.deleteUser(userId, token);
      if (success) {
        await storage.deleteAll();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus akun')),
        );
      }
    }
  }

  void editAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AkunEditPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akun')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Gagal memuat data pengguna'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: loadUserData,
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title:
                              Text(name, style: const TextStyle(fontSize: 20)),
                          subtitle: Text(email),
                        ),
                        const SizedBox(height: 30),

                        // Row untuk tombol Edit dan Delete berdampingan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: editAccount,
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Akun'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => deleteAccount(context),
                                icon: const Icon(Icons.delete),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                label: const Text('Hapus Akun'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Tombol Logout di bawah dengan full width
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => logout(context),
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    )),
    );
  }
}
