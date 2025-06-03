import 'package:flutter/material.dart';
import 'package:laundry_express/services/order_service.dart';

class OrderEditPage extends StatefulWidget {
  final Map<String, dynamic> order;
  OrderEditPage({required this.order});

  @override
  _OrderEditPageState createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
  final _formKey = GlobalKey<FormState>();
  String? productName;
  double? quantity;
  String? status;

  // List enum sesuai backend (Huruf kapital awal)
  final List<String> productNames = ['Cepat', 'Kilat', 'Mantap'];
  final List<String> statuses = ['Pending', 'Processing', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    // Sesuaikan nilai awal supaya cocok enum backend
    productName = _capitalize(widget.order['productName']);
    status = _capitalize(widget.order['status']);
    quantity = double.tryParse(widget.order['quantity'].toString()) ?? 0;
  }

  String _capitalize(String? value) {
    if (value == null || value.isEmpty) return '';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Order')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            DropdownButtonFormField<String>(
              value: productName,
              decoration: InputDecoration(labelText: 'Product Name'),
              items: productNames.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  productName = value;
                });
              },
              validator: (value) => value == null || value.isEmpty ? 'Pilih produk' : null,
            ),
            DropdownButtonFormField<String>(
              value: status,
              decoration: InputDecoration(labelText: 'Status'),
              items: statuses.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
              validator: (value) => value == null || value.isEmpty ? 'Pilih status' : null,
            ),
            TextFormField(
              initialValue: quantity != null ? quantity.toString() : '',
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Harus diisi';
                final numValue = double.tryParse(value);
                if (numValue == null || numValue <= 0) return 'Masukkan angka positif';
                return null;
              },
              onSaved: (value) => quantity = double.parse(value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final success = await OrderService.updateOrder(
                    widget.order['id'],
                    {
                      'productName': productName,
                      'quantity': quantity,
                      'status': status,
                    },
                  );
                  if (success) Navigator.pop(context, true);
                }
              },
              child: Text('Update'),
            )
          ]),
        ),
      ),
    );
  }
}
