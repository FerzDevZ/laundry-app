// ✅ package_page.dart — Menampilkan daftar paket laundry dan isi detailnya
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  List packages = [];
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/packages'));
      if (response.statusCode == 200) {
        setState(() {
          packages = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Gagal memuat data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Terjadi error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> showPackageForm({Map? data}) async {
    final nameController = TextEditingController(text: data?['PackageName'] ?? '');
    final descController = TextEditingController(text: data?['Description'] ?? '');
    final priceController = TextEditingController(text: data?['Price']?.toString() ?? '');
    final unitController = TextEditingController(text: data?['Unit']?['UnitName'] ?? '');
    final _formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    await showDialog(
      context: context,
      barrierDismissible: !isSubmitting,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Icon(data == null ? Icons.add_box : Icons.edit, color: Color(0xFF4e54c8)),
              const SizedBox(width: 8),
              Text(data == null ? 'Tambah Paket' : 'Edit Paket'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Paket', prefixIcon: Icon(Icons.inventory_2)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Deskripsi', prefixIcon: Icon(Icons.description)),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Harga', prefixIcon: Icon(Icons.attach_money)),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Harga wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: unitController,
                    decoration: const InputDecoration(labelText: 'Unit', prefixIcon: Icon(Icons.straighten)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Unit wajib diisi' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4e54c8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: isSubmitting ? 0 : 4,
              ),
              icon: isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(data == null ? Icons.add : Icons.save),
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;
                      setStateDialog(() => isSubmitting = true);
                      final body = {
                        "PackageName": nameController.text,
                        "Description": descController.text,
                        "Price": int.tryParse(priceController.text) ?? 0,
                        "UnitName": unitController.text,
                      };
                      if (data == null) {
                        // CREATE
                        await http.post(
                          Uri.parse('http://localhost:3000/api/packages'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(body),
                        );
                      } else {
                        // UPDATE
                        await http.put(
                          Uri.parse('http://localhost:3000/api/packages/${data['id']}'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(body),
                        );
                      }
                      if (context.mounted) Navigator.pop(context);
                      fetchPackages();
                    },
              label: Text(data == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deletePackage(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus paket ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await http.delete(Uri.parse('http://localhost:3000/api/packages/$id'));
      fetchPackages();
    }
  }

  Widget buildPackageCard(Map p) {
    final String name = p['PackageName'] ?? p['ServiceName'] ?? '-';
    final String desc = p['Description'] ?? '-';
    final String unit = p['Unit']?['UnitName'] ?? p['UnitName'] ?? '-';
    final price = p['Price'];
    final String priceStr = price != null ? "Rp${price.toString()}" : "-";

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 7,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple[50],
              child: const Icon(Icons.inventory_2, color: Color(0xFF4e54c8), size: 28),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4e54c8)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(desc, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Chip(
                        label: Text(unit, style: const TextStyle(color: Color(0xFF4e54c8))),
                        backgroundColor: Colors.deepPurple[50],
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Text(priceStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => showPackageForm(data: p),
                  ),
                ),
                Tooltip(
                  message: 'Hapus',
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletePackage(p['id']),
                  ),
                ),
              ],
            ),
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
        title: const Text("Paket Laundry"),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchPackages,
        color: Colors.deepPurple,
        backgroundColor: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : errorMsg != null
                ? Center(
                    child: Text(
                      errorMsg!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                : packages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, color: Colors.white.withOpacity(0.7), size: 64),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum ada paket laundry',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: packages.length,
                        itemBuilder: (context, index) => buildPackageCard(packages[index]),
                      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showPackageForm(),
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
