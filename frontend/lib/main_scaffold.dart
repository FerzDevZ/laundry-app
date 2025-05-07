import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/customer_page.dart';
import 'pages/service_page.dart';
import 'pages/package_page.dart';
import 'pages/transaction_page.dart';
import 'pages/pickup_request_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    CustomerPage(),
    ServicePage(),
    PackagePage(),
    TransactionPage(),
    PickupRequestPage(), // <-- Tambahkan ini
  ];

  final List<String> _titles = [
    "Dashboard",
    "Customer",
    "Service",
    "Package",
    "Transaction",
    "Pickup Request", // <-- Tambahkan ini
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Tutup drawer setelah pilih menu
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(child: Text("Esemka Laundry", style: TextStyle(color: Colors.white, fontSize: 20))),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Customer"),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.local_laundry_service),
              title: const Text("Service"),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Package"),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("Transaction"),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text("Pickup Request"),
              selected: _selectedIndex == 5,
              onTap: () => _onItemTapped(5),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}