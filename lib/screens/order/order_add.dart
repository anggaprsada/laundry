import 'package:flutter/material.dart';
import 'package:laundry_express/services/customer_service.dart';
import 'package:laundry_express/services/order_service.dart';


class OrderAddPage extends StatefulWidget {
  @override
  _OrderAddPageState createState() => _OrderAddPageState();
}

class _OrderAddPageState extends State<OrderAddPage> {
  final _formKey = GlobalKey<FormState>();
  int? customerId;
  String? productName;
  double? quantity;

  List<dynamic> customers = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final data = await CustomerService.getCustomers();
    setState(() {
      customers = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Order')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            DropdownButtonFormField<int>(
              value: customerId,
              decoration: InputDecoration(labelText: 'Customer'),
              items: customers.map<DropdownMenuItem<int>>((customer) {
                return DropdownMenuItem<int>(
                  value: customer['id'],
                  child: Text(customer['name']),
                );
              }).toList(),
              onChanged: (value) => setState(() {
                customerId = value;
              }),
              validator: (value) => value == null ? 'Pilih customer' : null,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Product Name'),
              items: ['Cepat', 'Kilat', 'Mantap'].map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) => productName = value,
              validator: (value) => value == null ? 'Pilih produk' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
              onSaved: (value) => quantity = double.tryParse(value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final success = await OrderService.addOrder({
                    'customer_id': customerId,
                    'productName': productName,
                    'quantity': quantity,
                  });
                  if (success) Navigator.pop(context, true);
                }
              },
              child: Text('Simpan'),
            )
          ]),
        ),
      ),
    );
  }
}
