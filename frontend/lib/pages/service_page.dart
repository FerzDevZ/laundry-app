// ✅ service_page.dart — Menampilkan semua layanan laundry
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List services = [];

  // Tambahkan controller untuk form
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final estimationController = TextEditingController();
  final categoryController = TextEditingController();
  final unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/services'));
    if (response.statusCode == 200) {
      setState(() {
        services = jsonDecode(response.body);
      });
    }
  }

  Future<void> showServiceForm() async {
    nameController.clear();
    priceController.clear();
    estimationController.clear();
    categoryController.clear();
    unitController.clear();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Tambah Layanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Layanan'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: estimationController,
                decoration: const InputDecoration(labelText: 'Estimasi (jam)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'ID Kategori'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'ID Unit'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Tambah'),
            onPressed: () async {
              final name = nameController.text.trim();
              final price = int.tryParse(priceController.text.trim()) ?? 0;
              final estimation = int.tryParse(estimationController.text.trim()) ?? 0;
              final categoryId = int.tryParse(categoryController.text.trim());
              final unitId = int.tryParse(unitController.text.trim());

              if (name.isEmpty || price == 0 || estimation == 0 || categoryId == null || unitId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field wajib diisi'), backgroundColor: Colors.red),
                );
                return;
              }

              final res = await http.post(
                Uri.parse('http://localhost:3000/api/services'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'ServiceName': name,
                  'Price': price,
                  'EstimationTime': estimation,
                  'CategoryID': categoryId,
                  'UnitID': unitId,
                }),
              );
              if (res.statusCode == 201) {
                Navigator.pop(context);
                fetchServices();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Layanan berhasil ditambah'), backgroundColor: Colors.deepPurple),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menambah layanan'), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4e54c8),
      appBar: AppBar(
        title: const Text("Layanan Laundry"),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchServices,
        color: Colors.deepPurple,
        backgroundColor: Colors.white,
        child: services.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple[50],
                            child: const Icon(Icons.local_laundry_service, color: Color(0xFF4e54c8), size: 28),
                          ),
                          title: Text(
                            s['ServiceName'],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4e54c8)),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Chip(
                                  label: Text("Rp${s['Price']}", style: const TextStyle(color: Color(0xFF4e54c8))),
                                  backgroundColor: Colors.deepPurple[50],
                                  visualDensity: VisualDensity.compact,
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text("Unit: ${s['Unit']?['UnitName'] ?? '-'}", style: const TextStyle(color: Color(0xFF4e54c8))),
                                  backgroundColor: Colors.deepPurple[50],
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                          trailing: Tooltip(
                            message: "Layanan laundry",
                            child: const Icon(Icons.check_circle, color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showServiceForm,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        backgroundColor: const Color(0xFF4e54c8),
      ),
    );
  }
}