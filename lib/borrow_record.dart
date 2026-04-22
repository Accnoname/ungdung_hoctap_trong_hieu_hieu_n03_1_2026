// ============================================================
// File: BorrowRecord.dart
// Mô tả: Đối tượng BorrowRecord (Phiếu mượn sách)
// Project: Quản lý Thư viện - Flutter
// ============================================================

enum BorrowStatus {
  borrowing, // Đang mượn
  returned, // Đã trả
  overdue, // Quá hạn
  lost, // Báo mất
}

class BorrowRecord {
  // ----------------------------------------------------------
  // BIẾN THÀNH VIÊN
  // ----------------------------------------------------------

  /// Mã phiếu mượn (duy nhất)
  final String recordId;

  /// Mã thành viên mượn sách
  final String memberId;

  /// Tên thành viên (lưu cache để hiển thị nhanh)
  String memberName;

  /// Mã sách được mượn
  final String bookId;

  /// Tên sách (lưu cache để hiển thị nhanh)
  String bookTitle;

  /// Tên tác giả
  String bookAuthor;

  /// Ngày mượn
  final DateTime borrowDate;

  /// Ngày phải trả (hạn trả)
  DateTime dueDate;

  /// Ngày thực tế đã trả (null nếu chưa trả)
  DateTime? returnDate;

  /// Trạng thái phiếu mượn
  BorrowStatus status;

  /// Ghi chú thêm
  String note;

  /// Số ngày quá hạn (0 nếu chưa quá hạn)
  int get overdueDays {
    if (status == BorrowStatus.returned) return 0;
    final today = DateTime.now();
    if (today.isAfter(dueDate)) {
      return today.difference(dueDate).inDays;
    }
    return 0;
  }

  /// Số ngày còn lại trước khi đến hạn (âm nếu đã quá hạn)
  int get daysRemaining {
    if (status == BorrowStatus.returned) return 0;
    return dueDate.difference(DateTime.now()).inDays;
  }

  /// Tên trạng thái tiếng Việt
  String get statusName {
    switch (status) {
      case BorrowStatus.borrowing:
        return 'Đang mượn';
      case BorrowStatus.returned:
        return 'Đã trả';
      case BorrowStatus.overdue:
        return 'Quá hạn';
      case BorrowStatus.lost:
        return 'Báo mất';
    }
  }

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------

  BorrowRecord({
    required this.recordId,
    required this.memberId,
    required this.memberName,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.status = BorrowStatus.borrowing,
    this.note = '',
  });

  // ----------------------------------------------------------
  // PHƯƠNG THỨC
  // ----------------------------------------------------------

  /// Trả sách — cập nhật ngày trả và trạng thái
  bool returnBook() {
    if (status == BorrowStatus.returned) return false;
    returnDate = DateTime.now();
    status = BorrowStatus.returned;
    return true;
  }

  /// Gia hạn thêm [days] ngày
  bool extendDueDate(int days) {
    if (status != BorrowStatus.borrowing) return false;
    dueDate = dueDate.add(Duration(days: days));
    return true;
  }

  /// Kiểm tra và cập nhật trạng thái quá hạn
  void checkOverdue() {
    if (status == BorrowStatus.borrowing && DateTime.now().isAfter(dueDate)) {
      status = BorrowStatus.overdue;
    }
  }

  // ----------------------------------------------------------
  // SERIALIZATION
  // ----------------------------------------------------------

  Map<String, dynamic> toMap() => {
    'recordId': recordId,
    'memberId': memberId,
    'memberName': memberName,
    'bookId': bookId,
    'bookTitle': bookTitle,
    'bookAuthor': bookAuthor,
    'borrowDate': borrowDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'returnDate': returnDate?.toIso8601String(),
    'status': status.name,
    'note': note,
  };

  factory BorrowRecord.fromMap(Map<String, dynamic> map) => BorrowRecord(
    recordId: map['recordId'],
    memberId: map['memberId'],
    memberName: map['memberName'],
    bookId: map['bookId'],
    bookTitle: map['bookTitle'],
    bookAuthor: map['bookAuthor'],
    borrowDate: DateTime.parse(map['borrowDate']),
    dueDate: DateTime.parse(map['dueDate']),
    returnDate: map['returnDate'] != null
        ? DateTime.parse(map['returnDate'])
        : null,
    status: BorrowStatus.values.firstWhere((e) => e.name == map['status']),
    note: map['note'] ?? '',
  );

  @override
  String toString() =>
      'BorrowRecord{id: $recordId, book: $bookTitle, member: $memberName, status: $statusName}';

  @override
  bool operator ==(Object other) =>
      other is BorrowRecord && other.recordId == recordId;

  @override
  int get hashCode => recordId.hashCode;
}
