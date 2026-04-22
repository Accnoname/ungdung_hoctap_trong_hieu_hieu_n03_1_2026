import 'Book.dart';

class ListBook {
  List<Book> _database = [];

  void create(Book book) {
    _database.add(book);
    print("Thêm thành công: ${book.title}");
  }

  void readAll() {
    if (_database.isEmpty) {
      print("Danh sách trống.");
    } else {
      print("--- Danh sách sách hiện có ---");
      for (var item in _database) {
        item.showInfo();
      }
    }
  }

  void edit(String id, String newTitle, double newPrice) {
    try {
      var book = _database.firstWhere((item) => item.id == id);
      book.title = newTitle;
      book.price = newPrice;
      print("Cập nhật thành công sách có ID: $id");
    } catch (e) {
      print("Không tìm thấy sách có ID: $id để sửa.");
    }
  }
}

void main() {
  ListBook manager = ListBook();

  manager.create(
    Book(id: "B001", title: "Lập trình Dart", author: "Google", price: 100000),
  );
  manager.create(
    Book(
      id: "B002",
      title: "Flutter nâng cao",
      author: "Community",
      price: 200000,
    ),
  );

  manager.readAll();

  manager.edit("B001", "Lập trình Dart & Flutter", 150000);

  manager.readAll();
}
