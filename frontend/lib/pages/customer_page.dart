import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List customers = [];
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool isEditing = false;
  int? editId;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final res = await http.get(Uri.parse('http://localhost:3000/api/customers'));
    if (res.statusCode == 200) {
      setState(() {
        customers = jsonDecode(res.body);
      });
    }
  }

  Future<void> saveCustomer() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi'), backgroundColor: Colors.red),
      );
      return;
    }

    final url = isEditing
        ? 'http://localhost:3000/api/customers/$editId'
        : 'http://localhost:3000/api/customers';
    final method = isEditing ? 'PUT' : 'POST';

    final res = await http.Request(method, Uri.parse(url))
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'Name': name,
        'PhoneNumber': phone,
        'Address': address,
      });

    final streamed = await res.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
      fetchCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Customer berhasil diupdate' : 'Customer berhasil ditambah'),
          backgroundColor: const Color(0xFF4e54c8),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan customer'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> deleteCustomer(int id) async {
    final res = await http.delete(Uri.parse('http://localhost:3000/api/customers/$id'));
    if (res.statusCode == 200) {
      fetchCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer dihapus'), backgroundColor: Colors.deepPurple),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus customer'), backgroundColor: Colors.red),
      );
    }
  }

  void showForm({Map? data}) {
    isEditing = data != null;
    editId = data?['id'];
    nameController.text = data?['Name'] ?? '';
    phoneController.text = data?['PhoneNumber'] ?? '';
    addressController.text = data?['Address'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? "Edit Customer" : "Tambah Customer",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4e54c8))),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4e54c8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'No HP',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF4e54c8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF4e54c8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  onPressed: saveCustomer,
                  label: Text(isEditing ? 'Update' : 'Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4e54c8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
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
        title: const Text("Data Customer"),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchCustomers,
        color: Colors.deepPurple,
        backgroundColor: Colors.white,
        child: customers.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final c = customers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.teal, size: 32),
                      title: Text(c['Name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${c['PhoneNumber']} | ${c['Address']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => showForm(data: c),
                            icon: const Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () => deleteCustomer(c['id']),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF4e54c8),
        tooltip: "Tambah Customer",
      ),
    );
  }
}
