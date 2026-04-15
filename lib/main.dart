import 'package:flutter/material.dart';

// Cau 1: Bien mo ta doi tuong Sach.
int idSach = 1;
String tenSach = 'Mobile Dev';
int soLuong = 10;
String nxb = 'Giao Duc';
String namXB = '2026';

// Cau 2: Collections (Array/List/Map) cho Nguoi Muon va Sach.
// Dart khong co kieu Array rieng, su dung List de dong vai tro mang.
List<String> mangNhaXuatBan = ['Giao Duc', 'Thanh Nien', 'Ollien'];

Map<String, dynamic> listNguoiMuon = {'id': 1, 'tenNguoiMuon': 'Nguyen Van A'};

List<Map<String, dynamic>> listSach = [
  {
    'idSach': 1,
    'tenSach': 'Mobile Dev',
    'soLuong': 10,
    'NXB': 'Giao Duc',
    'namXB': '2026',
  },
  {
    'idSach': 2,
    'tenSach': 'Lam quen voi Flutter',
    'soLuong': 100,
    'NXB': 'Thanh Nien',
    'namXB': '2024',
  },
  {
    'idSach': 3,
    'tenSach': 'Dart Programming',
    'soLuong': 100,
    'NXB': 'Ollien',
    'namXB': '2024',
  },
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quan Ly Thu Vien',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyHomePage(title: 'Bai Tap Thuc Hanh So 2'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Text(
              '1) Bien mo ta doi tuong Sach',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('idSach: $idSach'),
            Text('tenSach: $tenSach'),
            Text('soLuong: $soLuong'),
            Text('NXB: $nxb'),
            Text('namXB: $namXB'),
            const SizedBox(height: 20),
            const Text(
              '2) Collections - Nguoi Muon (Map)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('ID: ${listNguoiMuon['id']}')),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Ten nguoi muon: ${listNguoiMuon['tenNguoiMuon']}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '3) Collections - Danh sach Sach (List<Map>)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...listSach.map(
              (sach) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('idSach: ${sach['idSach']}')),
                          Expanded(child: Text('soLuong: ${sach['soLuong']}')),
                        ],
                      ),
                      Text('tenSach: ${sach['tenSach']}'),
                      Text('NXB: ${sach['NXB']}'),
                      Text('namXB: ${sach['namXB']}'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '4) Collections - Mang Nha Xuat Ban (Array/List)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...mangNhaXuatBan.map((nxbItem) => Text('- $nxbItem')),
          ],
        ),
      ),
    );
  }
}
