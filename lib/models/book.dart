// ============================================================
// File: Book.dart
// Mô tả: Đối tượng Book (Sách) trong hệ thống Quản lý Thư viện
// Author: [Tên sinh viên]
// MSSV:   [Mã số sinh viên]
// ============================================================

import 'dart:convert';

// Enum trạng thái sách
enum BookStatus {
  available, // Có sẵn
  borrowed, // Đang được mượn
  reserved, // Đã được đặt trước
  lost, // Bị mất
  maintenance, // Đang bảo trì / tu sửa
}

// Enum thể loại sách
enum BookCategory {
  fiction, // Tiểu thuyết
  nonFiction, // Phi hư cấu
  science, // Khoa học
  technology, // Công nghệ
  history, // Lịch sử
  literature, // Văn học
  children, // Thiếu nhi
  reference, // Tham khảo
  other, // Khác
}

// ============================================================
// Class chính: Book
// ============================================================
class Book {
  // ----------------------------------------------------------
  // BIẾN THÀNH VIÊN (Instance Variables)
  // ----------------------------------------------------------

  /// Mã sách (ISBN hoặc mã nội bộ thư viện) - duy nhất
  final String bookId;

  /// Tiêu đề sách
  String title;

  /// Tên tác giả (có thể nhiều tác giả, phân cách bởi dấu phẩy)
  String author;

  /// Nhà xuất bản
  String publisher;

  /// Năm xuất bản
  int publishYear;

  /// Thể loại sách
  BookCategory category;

  /// Mô tả / tóm tắt nội dung sách
  String description;

  /// Số trang
  int pageCount;

  /// Ngôn ngữ (ví dụ: "Tiếng Việt", "English")
  String language;

  /// Đường dẫn ảnh bìa sách (URL hoặc asset path)
  String coverImageUrl;

  /// Vị trí trên kệ sách (ví dụ: "A1-23")
  String shelfLocation;

  /// Tổng số lượng bản sao của đầu sách này trong thư viện
  int totalCopies;

  /// Số bản sao hiện đang có sẵn
  int availableCopies;

  /// Trạng thái sách
  BookStatus status;

  /// Ngày nhập sách vào thư viện
  DateTime dateAdded;

  /// Ngày cập nhật thông tin gần nhất
  DateTime dateUpdated;

  /// Số lần được mượn (thống kê)
  int borrowCount;

  /// Đánh giá trung bình (1.0 - 5.0)
  double rating;

  /// Số lượt đánh giá
  int ratingCount;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.publisher,
    required this.publishYear,
    required this.category,
    this.description = '',
    this.pageCount = 0,
    this.language = 'Tiếng Việt',
    this.coverImageUrl = '',
    this.shelfLocation = '',
    this.totalCopies = 1,
    this.availableCopies = 1,
    this.status = BookStatus.available,
    DateTime? dateAdded,
    DateTime? dateUpdated,
    this.borrowCount = 0,
    this.rating = 0.0,
    this.ratingCount = 0,
  }) : dateAdded = dateAdded ?? DateTime.now(),
       dateUpdated = dateUpdated ?? DateTime.now();

  // ----------------------------------------------------------
  // GETTER (Thuộc tính dẫn xuất)
  // ----------------------------------------------------------

  /// Kiểm tra sách có đang sẵn sàng để mượn không
  bool get isAvailable => status == BookStatus.available && availableCopies > 0;

  /// Số bản sao đang được mượn
  int get borrowedCopies => totalCopies - availableCopies;

  /// Tỷ lệ sử dụng (%)
  double get usageRate =>
      totalCopies > 0 ? (borrowedCopies / totalCopies) * 100 : 0.0;

  /// Hiển thị đánh giá dạng sao (ví dụ: "4.2 ★")
  String get ratingDisplay =>
      ratingCount > 0 ? '${rating.toStringAsFixed(1)} ★' : 'Chưa có đánh giá';

  /// Tên thể loại tiếng Việt
  String get categoryName {
    switch (category) {
      case BookCategory.fiction:
        return 'Tiểu thuyết';
      case BookCategory.nonFiction:
        return 'Phi hư cấu';
      case BookCategory.science:
        return 'Khoa học';
      case BookCategory.technology:
        return 'Công nghệ';
      case BookCategory.history:
        return 'Lịch sử';
      case BookCategory.literature:
        return 'Văn học';
      case BookCategory.children:
        return 'Thiếu nhi';
      case BookCategory.reference:
        return 'Tham khảo';
      case BookCategory.other:
        return 'Khác';
    }
  }

  /// Tên trạng thái tiếng Việt
  String get statusName {
    switch (status) {
      case BookStatus.available:
        return 'Có sẵn';
      case BookStatus.borrowed:
        return 'Đang được mượn';
      case BookStatus.reserved:
        return 'Đã đặt trước';
      case BookStatus.lost:
        return 'Bị mất';
      case BookStatus.maintenance:
        return 'Đang bảo trì';
    }
  }

  // ----------------------------------------------------------
  // PHƯƠNG THỨC CHÍNH (Methods)
  // ----------------------------------------------------------

  /// Mượn sách: giảm số bản sao có sẵn đi 1
  /// Trả về true nếu mượn thành công, false nếu không có sẵn
  bool borrowBook() {
    if (!isAvailable) return false;

    availableCopies--;
    borrowCount++;
    dateUpdated = DateTime.now();

    if (availableCopies == 0) {
      status = BookStatus.borrowed;
    }

    return true;
  }

  /// Trả sách: tăng số bản sao có sẵn lên 1
  /// Trả về true nếu trả thành công
  bool returnBook() {
    if (availableCopies >= totalCopies) return false;

    availableCopies++;
    dateUpdated = DateTime.now();

    if (availableCopies > 0 && status == BookStatus.borrowed) {
      status = BookStatus.available;
    }

    return true;
  }

  /// Đặt trước sách
  bool reserveBook() {
    if (!isAvailable) return false;

    status = BookStatus.reserved;
    dateUpdated = DateTime.now();
    return true;
  }

  /// Hủy đặt trước
  void cancelReservation() {
    if (status == BookStatus.reserved) {
      status = availableCopies > 0 ? BookStatus.available : BookStatus.borrowed;
      dateUpdated = DateTime.now();
    }
  }

  /// Thêm bản sao mới vào thư viện
  void addCopy({int count = 1}) {
    totalCopies += count;
    availableCopies += count;
    dateUpdated = DateTime.now();
    if (status != BookStatus.available) {
      status = BookStatus.available;
    }
  }

  /// Báo mất sách
  void reportLost({int count = 1}) {
    final lostCount = count.clamp(0, totalCopies);
    totalCopies -= lostCount;
    availableCopies = availableCopies.clamp(0, totalCopies);
    dateUpdated = DateTime.now();

    if (totalCopies == 0) {
      status = BookStatus.lost;
    }
  }

  /// Đưa sách vào trạng thái bảo trì
  void sendToMaintenance() {
    status = BookStatus.maintenance;
    dateUpdated = DateTime.now();
  }

  /// Hoàn thành bảo trì, sách trở về trạng thái bình thường
  void completeMaintenance() {
    status = availableCopies > 0 ? BookStatus.available : BookStatus.borrowed;
    dateUpdated = DateTime.now();
  }

  /// Thêm đánh giá mới cho sách
  /// [newRating]: giá trị từ 1.0 đến 5.0
  void addRating(double newRating) {
    assert(
      newRating >= 1.0 && newRating <= 5.0,
      'Đánh giá phải nằm trong khoảng 1.0 - 5.0',
    );

    final totalScore = rating * ratingCount + newRating;
    ratingCount++;
    rating = totalScore / ratingCount;
    dateUpdated = DateTime.now();
  }

  /// Cập nhật thông tin sách
  void updateInfo({
    String? title,
    String? author,
    String? publisher,
    int? publishYear,
    BookCategory? category,
    String? description,
    int? pageCount,
    String? language,
    String? coverImageUrl,
    String? shelfLocation,
  }) {
    if (title != null) this.title = title;
    if (author != null) this.author = author;
    if (publisher != null) this.publisher = publisher;
    if (publishYear != null) this.publishYear = publishYear;
    if (category != null) this.category = category;
    if (description != null) this.description = description;
    if (pageCount != null) this.pageCount = pageCount;
    if (language != null) this.language = language;
    if (coverImageUrl != null) this.coverImageUrl = coverImageUrl;
    if (shelfLocation != null) this.shelfLocation = shelfLocation;
    dateUpdated = DateTime.now();
  }

  /// Tìm kiếm: kiểm tra sách có khớp với từ khóa không
  /// (Tìm trong tiêu đề, tác giả, mô tả)
  bool matchesKeyword(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return title.toLowerCase().contains(lowerKeyword) ||
        author.toLowerCase().contains(lowerKeyword) ||
        description.toLowerCase().contains(lowerKeyword) ||
        bookId.toLowerCase().contains(lowerKeyword);
  }

  // ----------------------------------------------------------
  // SERIALIZATION (JSON)
  // ----------------------------------------------------------

  /// Chuyển đối tượng Book thành Map (để lưu DB / gửi API)
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'publisher': publisher,
      'publishYear': publishYear,
      'category': category.name,
      'description': description,
      'pageCount': pageCount,
      'language': language,
      'coverImageUrl': coverImageUrl,
      'shelfLocation': shelfLocation,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
      'status': status.name,
      'dateAdded': dateAdded.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'borrowCount': borrowCount,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  /// Tạo đối tượng Book từ Map (khi đọc từ DB / API)
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      bookId: map['bookId'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'] ?? '',
      publishYear: map['publishYear'] ?? 0,
      category: BookCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => BookCategory.other,
      ),
      description: map['description'] ?? '',
      pageCount: map['pageCount'] ?? 0,
      language: map['language'] ?? 'Tiếng Việt',
      coverImageUrl: map['coverImageUrl'] ?? '',
      shelfLocation: map['shelfLocation'] ?? '',
      totalCopies: map['totalCopies'] ?? 1,
      availableCopies: map['availableCopies'] ?? 1,
      status: BookStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookStatus.available,
      ),
      dateAdded: map['dateAdded'] != null
          ? DateTime.parse(map['dateAdded'])
          : DateTime.now(),
      dateUpdated: map['dateUpdated'] != null
          ? DateTime.parse(map['dateUpdated'])
          : DateTime.now(),
      borrowCount: map['borrowCount'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
    );
  }

  /// Chuyển sang JSON String
  String toJson() => jsonEncode(toMap());

  /// Tạo từ JSON String
  factory Book.fromJson(String source) => Book.fromMap(jsonDecode(source));

  /// Tạo bản sao (clone) với một số trường thay đổi
  Book copyWith({
    String? title,
    String? author,
    String? publisher,
    int? publishYear,
    BookCategory? category,
    String? description,
    int? pageCount,
    String? language,
    String? coverImageUrl,
    String? shelfLocation,
    int? totalCopies,
    int? availableCopies,
    BookStatus? status,
  }) {
    return Book(
      bookId: bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      publishYear: publishYear ?? this.publishYear,
      category: category ?? this.category,
      description: description ?? this.description,
      pageCount: pageCount ?? this.pageCount,
      language: language ?? this.language,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      shelfLocation: shelfLocation ?? this.shelfLocation,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
      status: status ?? this.status,
      dateAdded: dateAdded,
      dateUpdated: DateTime.now(),
      borrowCount: borrowCount,
      rating: rating,
      ratingCount: ratingCount,
    );
  }

  // ----------------------------------------------------------
  // OVERRIDE
  // ----------------------------------------------------------

  @override
  String toString() {
    return 'Book{'
        'bookId: $bookId, '
        'title: $title, '
        'author: $author, '
        'status: $statusName, '
        'available: $availableCopies/$totalCopies'
        '}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.bookId == bookId;
  }

  @override
  int get hashCode => bookId.hashCode;
}
