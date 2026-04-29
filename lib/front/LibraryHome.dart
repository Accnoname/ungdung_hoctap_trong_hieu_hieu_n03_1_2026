import 'package:flutter/material.dart';

class LibraryHome extends StatelessWidget {
  const LibraryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          'https://picsum.photos/seed/library/600/200',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Chào mừng đến với Thư Viện!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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