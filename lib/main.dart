import 'package:flutter/material.dart';

// --- Câu 2 ---
class DataBox<T> {
  T obj;
  DataBox(this.obj);
}

// --- Câu 3 ---
class Book {
  String id;
  String title;
  String author;
  double price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
  });
}

// --- Câu 4 ---
class ListBook {
  List<Book> _database = [];

  void create(Book book) {
    _database.add(book);
  }

  List<Book> getAll() => _database;

  void edit(String id, String newTitle, double newPrice) {
    int index = _database.indexWhere((b) => b.id == id);
    if (index != -1) {
      _database[index].title = newTitle;
      _database[index].price = newPrice;
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản Lý Thư Viện',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- Câu 4 ---
  final ListBook bookManager = ListBook();

  // --- Câu 2 ---
  final studentData = DataBox<List<Map<String, String>>>([
    {'studentID': 's123456', 'fullname': 'Nguyen Thi B'},
    {'studentID': 's345672', 'fullname': 'Nguyen Van D'},
    {'studentID': 's923333', 'fullname': 'Tran Thi Van'},
  ]);

  @override
  void initState() {
    super.initState();
    // --- Câu 4: Create ---
    bookManager.create(
      Book(id: "B01", title: "Lập trình Dart", author: "Google", price: 150000),
    );
    bookManager.create(
      Book(id: "B02", title: "Flutter Cơ Bản", author: "FPT", price: 200000),
    );
  }

  void _testEdit() {
    setState(() {
      // --- Câu 4: Edit ---
      bookManager.edit("B01", "Dart OOP Nâng Cao", 180000);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài Tập Thực Hành'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Câu 2 ---
            const Text(
              'Câu 2: Generic Class DataBox',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...studentData.obj.map(
              (s) => Text('ID: ${s['studentID']} - Tên: ${s['fullname']}'),
            ),

            const Divider(height: 32),

            // --- Câu 4: Read & Edit UI ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Câu 4: CRUD ListBook',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: _testEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Sửa sách B01'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Câu 4: Read ---
            ...bookManager.getAll().map(
              (book) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(child: Text(book.id)),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Tác giả: ${book.author}'),
                  trailing: Text(
                    '${book.price.toInt()}đ',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
