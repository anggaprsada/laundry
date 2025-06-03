import 'package:flutter/material.dart';
import 'package:laundry_express/screens/customer/customer_edit.dart';
import 'package:laundry_express/services/customer_service.dart';
import 'customer_add.dart';

class CustomerTab extends StatefulWidget {
  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  List<dynamic>? _customers;
  bool _isLoading = false;

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
    });
    final customers = await CustomerService.getAllCustomers();
    setState(() {
      _customers = customers;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _goToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerAddPage()),
    );
    if (result == true) {
      _loadCustomers();
    }
  }

  Future<void> _goToEditCustomer(Map<String, dynamic> customer) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerEditPage(
          id: customer['id'],
          initialName: customer['name'] ?? '',
          initialPhone: customer['phone'] ?? '',
        ),
      ),
    );

    if (result == true) {
      _loadCustomers(); // reload list kalau update berhasil
    }
  }

  Future<void> _deleteCustomer(int id) async {
    final success = await CustomerService.deleteCustomer(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer berhasil dihapus')),
      );
      _loadCustomers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus customer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pelanggan')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : (_customers == null || _customers!.isEmpty)
              ? Center(child: Text('Data pelanggan belum tersedia.'))
              : ListView.builder(
                  itemCount: _customers!.length,
                  itemBuilder: (context, index) {
                    final customer = _customers![index];
                    return ListTile(
                      title: Text(customer['name'] ?? '-'),
                      subtitle: Text(customer['phone'] ?? '-'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _goToEditCustomer(customer),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text('Yakin ingin hapus customer ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _deleteCustomer(customer['id']);
                              }
                            },
                            tooltip: 'Hapus',
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddCustomer,
        tooltip: 'Tambah Customer',
        child: Icon(Icons.add),
      ),
    );
  }
}
