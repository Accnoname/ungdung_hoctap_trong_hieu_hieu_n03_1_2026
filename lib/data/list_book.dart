// ============================================================
// File: ListBook.dart
// Mô tả: Quản lý danh sách sách + CRUD cho đối tượng Book
// Project: Quản lý Thư viện - Flutter
// ============================================================

import '../models/book.dart';

class ListBook {
  // ----------------------------------------------------------
  // BƯỚC 1: BIẾN DANH SÁCH CHÍNH
  // Đây là 01 biến duy nhất lưu toàn bộ danh sách sách
  // ----------------------------------------------------------
  List<Book> _books = [];

  // Getter công khai để đọc danh sách (không cho sửa trực tiếp từ ngoài)
  List<Book> get books => List.unmodifiable(_books);

  // ----------------------------------------------------------
  // BƯỚC 2: CREATE — Tạo 1 bản ghi Book mới và lưu vào danh sách
  // ----------------------------------------------------------

  /// Thêm 1 cuốn sách mới vào danh sách.
  /// Trả về true nếu thêm thành công, false nếu bookId đã tồn tại.
  bool createBook({
    required String bookId,
    required String title,
    required String author,
    required String publisher,
    required int publishYear,
    required BookCategory category,
    String description = '',
    int pageCount = 0,
    String language = 'Tiếng Việt',
    String coverImageUrl = '',
    String shelfLocation = '',
    int totalCopies = 1,
  }) {
    // Kiểm tra trùng bookId trước khi thêm
    if (_isIdExist(bookId)) {
      print('❌ CREATE THẤT BẠI: bookId "$bookId" đã tồn tại!');
      return false;
    }

    // Tạo đối tượng Book mới
    final newBook = Book(
      bookId: bookId,
      title: title,
      author: author,
      publisher: publisher,
      publishYear: publishYear,
      category: category,
      description: description,
      pageCount: pageCount,
      language: language,
      coverImageUrl: coverImageUrl,
      shelfLocation: shelfLocation,
      totalCopies: totalCopies,
      availableCopies: totalCopies,
    );

    // Lưu vào danh sách
    _books.add(newBook);
    print('✅ CREATE THÀNH CÔNG: Đã thêm sách "${newBook.title}" (ID: $bookId)');
    return true;
  }

  // ----------------------------------------------------------
  // BƯỚC 3: READ — Đọc dữ liệu từ danh sách
  // ----------------------------------------------------------

  /// [READ ALL] Đọc toàn bộ danh sách sách
  List<Book> readAll() {
    print('📖 READ ALL: Tổng cộng ${_books.length} cuốn sách.');
    return List.unmodifiable(_books);
  }

  /// [READ ONE] Đọc 1 cuốn sách theo bookId
  /// Trả về Book nếu tìm thấy, null nếu không có
  Book? readById(String bookId) {
    try {
      final book = _books.firstWhere((b) => b.bookId == bookId);
      print('📖 READ BY ID: Tìm thấy sách "${book.title}"');
      return book;
    } catch (_) {
      print('❌ READ BY ID: Không tìm thấy sách với ID "$bookId"');
      return null;
    }
  }

  /// [READ BY CATEGORY] Lọc sách theo thể loại
  List<Book> readByCategory(BookCategory category) {
    final result = _books.where((b) => b.category == category).toList();
    print(
      '📖 READ BY CATEGORY: Tìm thấy ${result.length} cuốn thể loại "${result.isNotEmpty ? result.first.categoryName : category.name}"',
    );
    return result;
  }

  /// [READ AVAILABLE] Chỉ lấy sách đang có sẵn để mượn
  List<Book> readAvailable() {
    final result = _books.where((b) => b.isAvailable).toList();
    print('📖 READ AVAILABLE: ${result.length} cuốn đang có sẵn.');
    return result;
  }

  /// [SEARCH] Tìm kiếm theo từ khóa (tiêu đề / tác giả / mô tả)
  List<Book> search(String keyword) {
    if (keyword.trim().isEmpty) return readAll();
    final result = _books.where((b) => b.matchesKeyword(keyword)).toList();
    print('🔍 SEARCH "$keyword": Tìm thấy ${result.length} kết quả.');
    return result;
  }

  // ----------------------------------------------------------
  // BƯỚC 4: UPDATE (EDIT) — Sửa 1 bản ghi theo bookId
  // ----------------------------------------------------------

  /// Cập nhật thông tin sách theo bookId.
  /// Chỉ truyền vào các trường muốn thay đổi (null = giữ nguyên).
  /// Trả về true nếu cập nhật thành công, false nếu không tìm thấy ID.
  bool updateBook({
    required String bookId, // ID cụ thể của bản ghi cần sửa
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
    BookStatus? status,
  }) {
    final index = _findIndexById(bookId);

    if (index == -1) {
      print('❌ UPDATE THẤT BẠI: Không tìm thấy sách với ID "$bookId"');
      return false;
    }

    // Lấy sách cũ và gọi updateInfo để cập nhật các trường
    final book = _books[index];
    book.updateInfo(
      title: title,
      author: author,
      publisher: publisher,
      publishYear: publishYear,
      category: category,
      description: description,
      pageCount: pageCount,
      language: language,
      coverImageUrl: coverImageUrl,
      shelfLocation: shelfLocation,
    );

    // Cập nhật thêm status nếu có
    if (status != null) {
      book.status = status;
    }

    print(
      '✅ UPDATE THÀNH CÔNG: Đã cập nhật sách "${book.title}" (ID: $bookId)',
    );
    return true;
  }

  // ----------------------------------------------------------
  // BƯỚC 5: DELETE — Xóa 1 bản ghi theo bookId
  // ----------------------------------------------------------

  /// Xóa sách theo bookId.
  /// Trả về true nếu xóa thành công, false nếu không tìm thấy.
  bool deleteBook(String bookId) {
    final index = _findIndexById(bookId);

    if (index == -1) {
      print('❌ DELETE THẤT BẠI: Không tìm thấy sách với ID "$bookId"');
      return false;
    }

    final removedTitle = _books[index].title;
    _books.removeAt(index);
    print('🗑️  DELETE THÀNH CÔNG: Đã xóa sách "$removedTitle" (ID: $bookId)');
    return true;
  }

  // ----------------------------------------------------------
  // TIỆN ÍCH — Thống kê nhanh
  // ----------------------------------------------------------

  /// Tổng số đầu sách
  int get totalBooks => _books.length;

  /// Tổng số sách đang có sẵn
  int get totalAvailable => _books.where((b) => b.isAvailable).length;

  /// Tổng số sách đang được mượn
  int get totalBorrowed => _books.fold(0, (sum, b) => sum + b.borrowedCopies);

  /// In thống kê tổng quan ra console
  void printSummary() {
    print('====================================');
    print('📚 THỐNG KÊ THƯ VIỆN');
    print('  Tổng đầu sách     : $totalBooks');
    print('  Đang có sẵn       : $totalAvailable');
    print('  Đang được mượn    : $totalBorrowed');
    print('====================================');
  }

  /// In toàn bộ danh sách ra console (để debug)
  void printAll() {
    if (_books.isEmpty) {
      print('📭 Danh sách sách trống!');
      return;
    }
    print('\n===== DANH SÁCH SÁCH =====');
    for (int i = 0; i < _books.length; i++) {
      final b = _books[i];
      print(
        '[${i + 1}] ${b.bookId} | ${b.title} | ${b.author} '
        '| ${b.statusName} | ${b.availableCopies}/${b.totalCopies} bản',
      );
    }
    print('==========================\n');
  }

  // ----------------------------------------------------------
  // PRIVATE HELPERS — Hàm nội bộ
  // ----------------------------------------------------------

  /// Kiểm tra bookId đã tồn tại trong danh sách chưa
  bool _isIdExist(String bookId) => _books.any((b) => b.bookId == bookId);

  /// Tìm chỉ số (index) của sách theo bookId, trả về -1 nếu không có
  int _findIndexById(String bookId) =>
      _books.indexWhere((b) => b.bookId == bookId);
}

// ==============================================================
// HÀM DEMO — Chạy thử toàn bộ CRUD (xóa khi tích hợp thật)
// ==============================================================
void main() {
  final library = ListBook();

  print('\n🟢 ===== DEMO CRUD - QUẢN LÝ THƯ VIỆN =====\n');

  // ---- CREATE ----
  print('--- CREATE ---');
  library.createBook(
    bookId: 'B001',
    title: 'Lập trình Flutter từ cơ bản đến nâng cao',
    author: 'Nguyễn Văn A',
    publisher: 'NXB Giáo Dục',
    publishYear: 2023,
    category: BookCategory.technology,
    pageCount: 350,
    shelfLocation: 'A1-01',
    totalCopies: 3,
  );

  library.createBook(
    bookId: 'B002',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    publisher: 'Prentice Hall',
    publishYear: 2008,
    category: BookCategory.technology,
    pageCount: 431,
    language: 'English',
    shelfLocation: 'A1-02',
    totalCopies: 2,
  );

  library.createBook(
    bookId: 'B003',
    title: 'Truyện Kiều',
    author: 'Nguyễn Du',
    publisher: 'NXB Văn Học',
    publishYear: 2020,
    category: BookCategory.literature,
    pageCount: 200,
    shelfLocation: 'B2-05',
    totalCopies: 5,
  );

  // Thử tạo trùng ID
  library.createBook(
    bookId: 'B001',
    title: 'Sách trùng ID',
    author: '???',
    publisher: '???',
    publishYear: 2024,
    category: BookCategory.other,
  );

  // ---- READ ----
  print('\n--- READ ALL ---');
  library.printAll();

  print('--- READ BY ID: B002 ---');
  final book = library.readById('B002');
  if (book != null) print('  => ${book.title} - ${book.author}');

  print('\n--- READ BY CATEGORY: technology ---');
  final techBooks = library.readByCategory(BookCategory.technology);
  for (var b in techBooks) print('  => ${b.title}');

  print('\n--- SEARCH: "flutter" ---');
  final found = library.search('flutter');
  for (var b in found) print('  => ${b.title}');

  // ---- UPDATE ----
  print('\n--- UPDATE: B001 ---');
  library.updateBook(
    bookId: 'B001',
    title: 'Lập trình Flutter - Phiên bản cập nhật 2024',
    shelfLocation: 'A1-10',
  );
  print('  Sau update: ${library.readById('B001')?.title}');

  // ---- DELETE ----
  print('\n--- DELETE: B003 ---');
  library.deleteBook('B003');

  // Thử xóa ID không tồn tại
  library.deleteBook('B999');

  // ---- TỔNG KẾT ----
  print('');
  library.printAll();
  library.printSummary();
}
