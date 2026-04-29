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


  void showInfo() {
    print("Mã sách: $id | Tiêu đề: $title | Tác giả: $author | Giá: $price");
  }


  void updatePrice(double newPrice) {
    this.price = newPrice;
    print("Đã cập nhật giá mới cho sách $title");
  }
}