import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  List customers = [];
  List services = [];
  List packages = [];

  int? selectedCustomer;
  int? selectedService;
  int? selectedPackage;
  int quantity = 1;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final c = await http.get(Uri.parse('http://localhost:3000/api/customers'));
    final s = await http.get(Uri.parse('http://localhost:3000/api/services'));
    final p = await http.get(Uri.parse('http://localhost:3000/api/packages'));
    setState(() {
      customers = jsonDecode(c.body);
      services = jsonDecode(s.body);
      packages = jsonDecode(p.body);
    });
  }

  Future<void> submitTransaction() async {
    setState(() => isLoading = true);
    final body = {
      "CustomerID": selectedCustomer,
      "details": [
        if (selectedService != null)
          {
            "ServiceID": selectedService,
            "Quantity": quantity,
          },
        if (selectedPackage != null)
          {
            "PackageID": selectedPackage,
            "Quantity": quantity,
          },
      ]
    };
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    setState(() => isLoading = false);
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil ditambah'), backgroundColor: Colors.deepPurple),
        );
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambah transaksi'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4e54c8),
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: fetchData,
              color: Colors.deepPurple,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Customer',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          value: selectedCustomer,
                          items: customers
                              .map<DropdownMenuItem<int>>((c) => DropdownMenuItem(
                                    value: c['id'],
                                    child: Text(c['Name']),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => selectedCustomer = v),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Service (opsional)',
                            prefixIcon: Icon(Icons.local_laundry_service_outlined),
                            border: OutlineInputBorder(),
                          ),
                          value: selectedService,
                          items: [
                            const DropdownMenuItem<int>(value: null, child: Text('-')),
                            ...services.map<DropdownMenuItem<int>>((s) => DropdownMenuItem(
                                  value: s['id'],
                                  child: Text(s['ServiceName']),
                                ))
                          ],
                          onChanged: (v) => setState(() => selectedService = v),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Package (opsional)',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                            border: OutlineInputBorder(),
                          ),
                          value: selectedPackage,
                          items: [
                            const DropdownMenuItem<int>(value: null, child: Text('-')),
                            ...packages.map<DropdownMenuItem<int>>((p) => DropdownMenuItem(
                                  value: p['id'],
                                  child: Text(p['PackageName']),
                                ))
                          ],
                          onChanged: (v) => setState(() => selectedPackage = v),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                            border: OutlineInputBorder(),
                          ),
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          onChanged: (v) => quantity = int.tryParse(v) ?? 1,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            onPressed: (selectedCustomer != null &&
                                    (selectedService != null || selectedPackage != null))
                                ? submitTransaction
                                : null,
                            label: const Text('Simpan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4e54c8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}