// ============================================================
// File: ListBorrowRecord.dart
// Mô tả: Quản lý danh sách phiếu mượn + CRUD
// Project: Quản lý Thư viện - Flutter
// ============================================================

import '../borrow_record.dart';

class ListBorrowRecord {
  // ----------------------------------------------------------
  // BIẾN DANH SÁCH CHÍNH
  // ----------------------------------------------------------
  List<BorrowRecord> _records = [];

  List<BorrowRecord> get records => List.unmodifiable(_records);

  // ----------------------------------------------------------
  // CREATE
  // ----------------------------------------------------------
  bool createRecord({
    required String recordId,
    required String memberId,
    required String memberName,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    int borrowDays = 14,
    String note = '',
  }) {
    if (_records.any((r) => r.recordId == recordId)) return false;

    final now = DateTime.now();
    _records.add(
      BorrowRecord(
        recordId: recordId,
        memberId: memberId,
        memberName: memberName,
        bookId: bookId,
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
        borrowDate: now,
        dueDate: now.add(Duration(days: borrowDays)),
        note: note,
      ),
    );
    return true;
  }

  // ----------------------------------------------------------
  // READ
  // ----------------------------------------------------------

  /// Đọc tất cả phiếu mượn
  List<BorrowRecord> readAll() => List.unmodifiable(_records);

  /// Đọc theo ID
  BorrowRecord? readById(String recordId) {
    try {
      return _records.firstWhere((r) => r.recordId == recordId);
    } catch (_) {
      return null;
    }
  }

  /// Lọc phiếu đang mượn
  List<BorrowRecord> readBorrowing() =>
      _records.where((r) => r.status == BorrowStatus.borrowing).toList();

  /// Lọc phiếu quá hạn
  List<BorrowRecord> readOverdue() {
    _records.forEach((r) => r.checkOverdue());
    return _records.where((r) => r.status == BorrowStatus.overdue).toList();
  }

  /// Lọc theo memberId
  List<BorrowRecord> readByMember(String memberId) =>
      _records.where((r) => r.memberId == memberId).toList();

  /// Lọc theo bookId
  List<BorrowRecord> readByBook(String bookId) =>
      _records.where((r) => r.bookId == bookId).toList();

  // ----------------------------------------------------------
  // UPDATE
  // ----------------------------------------------------------

  /// Trả sách theo recordId
  bool returnBook(String recordId) {
    final record = readById(recordId);
    if (record == null) return false;
    return record.returnBook();
  }

  /// Gia hạn mượn thêm ngày
  bool extendRecord(String recordId, {int days = 7}) {
    final record = readById(recordId);
    if (record == null) return false;
    return record.extendDueDate(days);
  }

  /// Cập nhật ghi chú
  bool updateNote(String recordId, String note) {
    final record = readById(recordId);
    if (record == null) return false;
    record.note = note;
    return true;
  }

  // ----------------------------------------------------------
  // DELETE
  // ----------------------------------------------------------
  bool deleteRecord(String recordId) {
    final index = _records.indexWhere((r) => r.recordId == recordId);
    if (index == -1) return false;
    _records.removeAt(index);
    return true;
  }

  // ----------------------------------------------------------
  // THỐNG KÊ
  // ----------------------------------------------------------
  int get totalRecords => _records.length;
  int get totalBorrowing => readBorrowing().length;
  int get totalOverdue => readOverdue().length;
  int get totalReturned =>
      _records.where((r) => r.status == BorrowStatus.returned).length;
}
