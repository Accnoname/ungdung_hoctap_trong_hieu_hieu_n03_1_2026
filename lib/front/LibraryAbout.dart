import 'package:flutter/material.dart';

class LibraryAbout extends StatelessWidget {
  const LibraryAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          'https://picsum.photos/seed/team/600/200',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ứng dụng  quản lý thư viện.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
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