import 'package:flutter/material.dart';
import 'package:laundry_express/services/order_service.dart';
import 'order_add.dart';
import 'order_edit.dart';

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  List<dynamic> orders = [];

  Future<void> loadOrders() async {
    final data = await OrderService.getOrders();
    setState(() {
      orders = data ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Order')),
      body: orders.isEmpty
          ? Center(child: Text('Belum ada data'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(
                      '${order['customer']?['name'] ?? 'Unknown'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal Order: ${order['orderDate']}'),
                      Text(
                          '${order['productName']} - ${order['quantity']} kg'),
                      Text('Harga: Rp ${order['price']}'),
                      Text('Status: ${order['status']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrderEditPage(order: order)),
                          );
                          if (updated == true) loadOrders();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Hapus'),
                              content: Text('Yakin ingin menghapus order ini?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text('Batal')),
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text('Hapus')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await OrderService.deleteOrder(order['id']);
                            loadOrders();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderAddPage()),
          );
          if (added == true) loadOrders();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
