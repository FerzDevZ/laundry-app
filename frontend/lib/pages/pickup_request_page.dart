import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PickupRequestPage extends StatefulWidget {
  const PickupRequestPage({super.key});

  @override
  State<PickupRequestPage> createState() => _PickupRequestPageState();
}

class _PickupRequestPageState extends State<PickupRequestPage> {
  List pickups = [];
  List customers = [];
  int? selectedCustomer;
  String address = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchPickups();
    fetchCustomers();
  }

  Future<void> fetchPickups() async {
    final res = await http.get(Uri.parse('http://localhost:3000/api/pickups'));
    if (res.statusCode == 200) {
      setState(() {
        pickups = jsonDecode(res.body);
      });
    }
  }

  Future<void> fetchCustomers() async {
    final res = await http.get(Uri.parse('http://localhost:3000/api/customers'));
    if (res.statusCode == 200) {
      setState(() {
        customers = jsonDecode(res.body);
      });
    }
  }

  Future<void> addPickup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final res = await http.post(
      Uri.parse('http://localhost:3000/api/pickups'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "CustomerID": selectedCustomer,
        "PickupAddress": address,
      }),
    );
    setState(() => isLoading = false);
    if (res.statusCode == 201 || res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pickup request berhasil dibuat!'),
          backgroundColor: Colors.deepPurple,
        ),
      );
      setState(() {
        address = '';
        selectedCustomer = null;
      });
      fetchPickups();
      _formKey.currentState!.reset(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal membuat pickup request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateStatus(int id, String status) async {
    final res = await http.put(
      Uri.parse('http://localhost:3000/api/pickups/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"status": status}),
    );
    if (res.statusCode == 200) {
      fetchPickups();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status pickup diubah menjadi $status'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  Widget buildPickupCard(Map p) {
    Color statusColor(String status) {
      switch (status) {
        case 'Pending':
          return Colors.orange;
        case 'Diambil':
          return Colors.blue;
        case 'Selesai':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple[50],
            child: const Icon(Icons.local_shipping, color: Colors.deepPurple, size: 28),
          ),
          title: Text(
            p['Customer']?['Name'] ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Alamat: ${p['PickupAddress']}", style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text("Status: ", style: TextStyle(fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor(p['Status']).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        p['Status'],
                        style: TextStyle(
                          color: statusColor(p['Status']),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (status) => updateStatus(p['id'], status),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Pending', child: Text('Pending')),
              const PopupMenuItem(value: 'Diambil', child: Text('Diambil')),
              const PopupMenuItem(value: 'Selesai', child: Text('Selesai')),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4e54c8),
      appBar: AppBar(
        title: const Text('Pickup Request'),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                        validator: (value) => value == null ? 'Pilih customer' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Alamat Pickup',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => address = v,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Alamat tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.add),
                          onPressed: isLoading ? null : addPickup,
                          label: const Text('Tambah Pickup'),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Daftar Pickup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchPickups,
              color: Colors.deepPurple,
              backgroundColor: Colors.white,
              child: pickups.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, color: Colors.white.withOpacity(0.7), size: 64),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada pickup request',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: pickups.length,
                      itemBuilder: (context, index) => buildPickupCard(pickups[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}