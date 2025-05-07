// ✅ transaction_page.dart — Menampilkan daftar transaksi laundry
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_transaction_page.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List transactions = [];
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/transactions'));
      if (response.statusCode == 200) {
        setState(() {
          transactions = jsonDecode(response.body);
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

  Widget buildTransactionCard(Map t) {
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 7,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  title: Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Color(0xFF4e54c8)),
                      const SizedBox(width: 8),
                      const Text('Detail Transaksi', style: TextStyle(color: Color(0xFF4e54c8))),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: ${t['Customer']?['Name'] ?? '-'}"),
                      Text("Tanggal: ${t['TransactionDate']?.toString().substring(0, 10)}"),
                      const SizedBox(height: 8),
                      const Text("Detail:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...List.generate(t['DetailTransactions']?.length ?? 0, (i) {
                        final d = t['DetailTransactions'][i];
                        final label = d['Service']?['ServiceName'] ?? d['Package']?['PackageName'] ?? '-';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFF4e54c8), size: 16),
                              const SizedBox(width: 4),
                              Text("- $label x${d['Quantity']} (Rp${d['Subtotal']})"),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup', style: TextStyle(color: Color(0xFF4e54c8))),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple[50],
                    radius: 28,
                    child: const Icon(Icons.receipt_long, color: Color(0xFF4e54c8), size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t['Customer']?['Name'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF4e54c8)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tanggal: ${t['TransactionDate']?.toString().substring(0, 10)}",
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: List.generate(t['DetailTransactions']?.length ?? 0, (i) {
                            final d = t['DetailTransactions'][i];
                            final label = d['Service']?['ServiceName'] ?? d['Package']?['PackageName'] ?? '-';
                            return Chip(
                              label: Text("$label x${d['Quantity']}"),
                              backgroundColor: Colors.deepPurple[50],
                              labelStyle: const TextStyle(color: Color(0xFF4e54c8)),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF4e54c8)),
                ],
              ),
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
        title: const Text("Transaksi Laundry"),
        backgroundColor: const Color(0xFF4e54c8),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchTransactions,
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
                : transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, color: Colors.white.withOpacity(0.7), size: 64),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum ada transaksi',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          return buildTransactionCard(transactions[index]);
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          );
          if (result == true) fetchTransactions();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        backgroundColor: const Color(0xFF4e54c8),
      ),
    );
  }
}
