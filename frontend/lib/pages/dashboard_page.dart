import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalCustomers = 0;
  int totalServices = 0;
  int totalPackages = 0;
  int totalTransactions = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    setState(() => isLoading = true);
    try {
      final customers = await http.get(Uri.parse('http://localhost:3000/api/customers'));
      final services = await http.get(Uri.parse('http://localhost:3000/api/services'));
      final packages = await http.get(Uri.parse('http://localhost:3000/api/packages'));
      final transactions = await http.get(Uri.parse('http://localhost:3000/api/transactions'));

      setState(() {
        totalCustomers = jsonDecode(customers.body).length;
        totalServices = jsonDecode(services.body).length;
        totalPackages = jsonDecode(packages.body).length;
        totalTransactions = jsonDecode(transactions.body).length;
        isLoading = false;
      });
      // Contoh notifikasi sukses
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Data dashboard berhasil diperbarui'), backgroundColor: Colors.deepPurple),
      // );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget buildCard(String label, int count, Color color, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {}, // Bisa tambahkan aksi jika perlu
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$count', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
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
        title: const Text("Dashboard Esemka Laundry"),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchDashboardData,
        color: Colors.deepPurple,
        backgroundColor: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.deepPurple[100],
                          child: const Icon(Icons.person, color: Colors.deepPurple),
                        ),
                        const SizedBox(width: 12),
                        const Text("Halo, Admin Esemka 👋", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          buildCard("Customer", totalCustomers, Colors.teal, Icons.people),
                          buildCard("Service", totalServices, Colors.orange, Icons.local_laundry_service),
                          buildCard("Package", totalPackages, Colors.blue, Icons.inventory),
                          buildCard("Transaksi", totalTransactions, Colors.purple, Icons.receipt_long),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
