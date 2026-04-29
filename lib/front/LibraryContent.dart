import 'package:flutter/material.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          'https://picsum.photos/seed/books/600/200',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: const [
              ListTile(leading: Icon(Icons.book), title: Text('Sách 1')),
              ListTile(leading: Icon(Icons.book), title: Text('Sách 2')),
              ListTile(leading: Icon(Icons.book), title: Text('Sách 3')),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
           'Phenikaa University, Nguyễn Trung Hiếu, Nguyễn Văn Trọng, Trương Bùi Huy Hiếu',
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }
}