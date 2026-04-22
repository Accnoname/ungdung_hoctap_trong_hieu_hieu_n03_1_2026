// ============================================================
// File: main.dart
// Mô tả: Giao diện demo Quản lý Phiếu Mượn Sách
// Project: Quản lý Thư viện - Flutter
// ============================================================

import 'package:flutter/material.dart';
import '../models/listborrowrecord.dart';
import 'borrow_record.dart';

void main() {
  runApp(const LibraryApp());
}

// ============================================================
// APP ROOT
// ============================================================
class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Thư Viện',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3C5E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A3C5E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          color: Colors.white,
        ),
      ),
      home: const BorrowListScreen(),
    );
  }
}

// ============================================================
// MÀNG HÌNH DANH SÁCH PHIẾU MƯỢN
// ============================================================
class BorrowListScreen extends StatefulWidget {
  const BorrowListScreen({super.key});

  @override
  State<BorrowListScreen> createState() => _BorrowListScreenState();
}

class _BorrowListScreenState extends State<BorrowListScreen>
    with SingleTickerProviderStateMixin {
  final ListBorrowRecord _listBorrow = ListBorrowRecord();
  late TabController _tabController;

  // Màu chủ đạo
  static const Color kNavy = Color(0xFF1A3C5E);
  static const Color kGold = Color(0xFFF5A623);
  static const Color kGreen = Color(0xFF27AE60);
  static const Color kRed = Color(0xFFE74C3C);
  static const Color kOrange = Color(0xFFE67E22);
  static const Color kBg = Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _seedDemoData();
  }

  // ---- Tạo dữ liệu mẫu ----
  void _seedDemoData() {
    _listBorrow.createRecord(
      recordId: 'PM001',
      memberId: 'TV001',
      memberName: 'Nguyễn Văn An',
      bookId: 'B001',
      bookTitle: 'Lập trình Flutter từ A-Z',
      bookAuthor: 'Nguyễn Minh Tuấn',
      borrowDays: 14,
    );
    _listBorrow.createRecord(
      recordId: 'PM002',
      memberId: 'TV002',
      memberName: 'Trần Thị Bình',
      bookId: 'B002',
      bookTitle: 'Clean Code',
      bookAuthor: 'Robert C. Martin',
      borrowDays: 7,
    );
    _listBorrow.createRecord(
      recordId: 'PM003',
      memberId: 'TV003',
      memberName: 'Lê Quốc Cường',
      bookId: 'B003',
      bookTitle: 'Truyện Kiều',
      bookAuthor: 'Nguyễn Du',
      borrowDays: 21,
    );
    // Tạo 1 phiếu quá hạn (dueDate trong quá khứ)
    _listBorrow.createRecord(
      recordId: 'PM004',
      memberId: 'TV004',
      memberName: 'Phạm Thị Dung',
      bookId: 'B004',
      bookTitle: 'Design Patterns',
      bookAuthor: 'Gang of Four',
      borrowDays: -3, // quá hạn 3 ngày
    );
    // Tạo 1 phiếu đã trả
    _listBorrow.createRecord(
      recordId: 'PM005',
      memberId: 'TV001',
      memberName: 'Nguyễn Văn An',
      bookId: 'B005',
      bookTitle: 'Đắc Nhân Tâm',
      bookAuthor: 'Dale Carnegie',
      borrowDays: 10,
    );
    _listBorrow.returnBook('PM005');
    _listBorrow.readOverdue(); // trigger cập nhật trạng thái quá hạn
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---- Lọc danh sách theo tab ----
  List<BorrowRecord> _getFilteredList() {
    switch (_tabController.index) {
      case 1:
        return _listBorrow.readBorrowing();
      case 2:
        return _listBorrow.readOverdue();
      default:
        return _listBorrow.readAll();
    }
  }

  // ---- Màu & icon theo trạng thái ----
  Color _statusColor(BorrowStatus s) {
    switch (s) {
      case BorrowStatus.borrowing:
        return kNavy;
      case BorrowStatus.returned:
        return kGreen;
      case BorrowStatus.overdue:
        return kRed;
      case BorrowStatus.lost:
        return kOrange;
    }
  }

  IconData _statusIcon(BorrowStatus s) {
    switch (s) {
      case BorrowStatus.borrowing:
        return Icons.menu_book_rounded;
      case BorrowStatus.returned:
        return Icons.check_circle_rounded;
      case BorrowStatus.overdue:
        return Icons.warning_rounded;
      case BorrowStatus.lost:
        return Icons.report_rounded;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSummaryCards(),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ---- AppBar ----
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kNavy,
      title: const Row(
        children: [
          Icon(Icons.local_library_rounded, color: Color(0xFFF5A623), size: 26),
          SizedBox(width: 10),
          Text('Quản Lý Thư Viện'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => _showSearchDialog(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ---- 4 thẻ thống kê ----
  Widget _buildSummaryCards() {
    final stats = [
      {
        'label': 'Tổng phiếu',
        'value': _listBorrow.totalRecords,
        'color': kNavy,
        'icon': Icons.receipt_long_rounded,
      },
      {
        'label': 'Đang mượn',
        'value': _listBorrow.totalBorrowing,
        'color': kGold,
        'icon': Icons.menu_book_rounded,
      },
      {
        'label': 'Quá hạn',
        'value': _listBorrow.totalOverdue,
        'color': kRed,
        'icon': Icons.warning_rounded,
      },
      {
        'label': 'Đã trả',
        'value': _listBorrow.totalReturned,
        'color': kGreen,
        'icon': Icons.check_circle_rounded,
      },
    ];

    return Container(
      color: kNavy,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Row(
        children: stats
            .map(
              (s) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        s['icon'] as IconData,
                        color: s['color'] as Color,
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${s['value']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s['label'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ---- Tab Bar ----
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: kNavy,
        unselectedLabelColor: Colors.grey,
        indicatorColor: kNavy,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        onTap: (_) => setState(() {}),
        tabs: const [
          Tab(text: 'Tất cả'),
          Tab(text: 'Đang mượn'),
          Tab(text: 'Quá hạn'),
        ],
      ),
    );
  }

  // ---- TabBarView ----
  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: List.generate(3, (_) => _buildRecordList()),
    );
  }

  // ---- Danh sách phiếu mượn ----
  Widget _buildRecordList() {
    final list = _getFilteredList();
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Không có dữ liệu',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: list.length,
      itemBuilder: (ctx, i) => _buildRecordCard(list[i]),
    );
  }

  // ---- Card phiếu mượn ----
  Widget _buildRecordCard(BorrowRecord record) {
    final color = _statusColor(record.status);
    final icon = _statusIcon(record.status);
    final isOverdue = record.status == BorrowStatus.overdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOverdue
            ? Border.all(color: kRed.withOpacity(0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Tên sách + badge trạng thái
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.bookTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1A2332),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record.bookAuthor,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(record),
              ],
            ),
            const SizedBox(height: 14),
            // Divider
            Divider(color: Colors.grey.shade100, height: 1),
            const SizedBox(height: 12),
            // Thông tin phiếu
            Row(
              children: [
                _infoChip(
                  Icons.person_rounded,
                  record.memberName,
                  Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                _infoChip(Icons.tag_rounded, record.recordId, Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoChip(
                  Icons.calendar_today_rounded,
                  'Mượn: ${_fmt(record.borrowDate)}',
                  Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                _infoChip(
                  Icons.event_rounded,
                  'Hạn: ${_fmt(record.dueDate)}',
                  isOverdue ? kRed : Colors.blueGrey,
                ),
              ],
            ),
            // Cảnh báo quá hạn
            if (isOverdue) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: kRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: kRed,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Quá hạn ${record.overdueDays} ngày!',
                      style: const TextStyle(
                        color: kRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Action buttons
            if (record.status == BorrowStatus.borrowing ||
                record.status == BorrowStatus.overdue) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      label: 'Trả sách',
                      icon: Icons.keyboard_return_rounded,
                      color: kGreen,
                      onTap: () => _onReturnBook(record),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _actionButton(
                      label: 'Gia hạn',
                      icon: Icons.update_rounded,
                      color: kNavy,
                      onTap: () => _onExtend(record),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---- Badge trạng thái ----
  Widget _buildStatusBadge(BorrowRecord record) {
    final color = _statusColor(record.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        record.statusName,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ---- Info chip ----
  Widget _infoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
        ),
      ],
    );
  }

  // ---- Action button ----
  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- FAB: Thêm phiếu mượn ----
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddDialog(),
      backgroundColor: kNavy,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'Thêm phiếu mượn',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  // ============================================================
  // DIALOGS & ACTIONS
  // ============================================================

  // ---- Dialog thêm phiếu mượn ----
  void _showAddDialog() {
    final recordIdCtrl = TextEditingController();
    final memberIdCtrl = TextEditingController();
    final memberNameCtrl = TextEditingController();
    final bookIdCtrl = TextEditingController();
    final bookTitleCtrl = TextEditingController();
    final bookAuthorCtrl = TextEditingController();
    int borrowDays = 14;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Thêm phiếu mượn mới',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A3C5E),
                  ),
                ),
                const SizedBox(height: 20),
                _dialogField(recordIdCtrl, 'Mã phiếu *', Icons.receipt_rounded),
                _dialogField(
                  memberIdCtrl,
                  'Mã thành viên *',
                  Icons.badge_rounded,
                ),
                _dialogField(
                  memberNameCtrl,
                  'Tên thành viên *',
                  Icons.person_rounded,
                ),
                _dialogField(bookIdCtrl, 'Mã sách *', Icons.book_rounded),
                _dialogField(bookTitleCtrl, 'Tên sách *', Icons.title_rounded),
                _dialogField(bookAuthorCtrl, 'Tác giả *', Icons.edit_rounded),
                // Số ngày mượn
                const SizedBox(height: 8),
                Text(
                  'Số ngày mượn: $borrowDays ngày',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3C5E),
                  ),
                ),
                Slider(
                  value: borrowDays.toDouble(),
                  min: 3,
                  max: 30,
                  divisions: 27,
                  activeColor: const Color(0xFF1A3C5E),
                  onChanged: (v) => setModalState(() => borrowDays = v.round()),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3C5E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final ok = _listBorrow.createRecord(
                        recordId: recordIdCtrl.text.trim(),
                        memberId: memberIdCtrl.text.trim(),
                        memberName: memberNameCtrl.text.trim(),
                        bookId: bookIdCtrl.text.trim(),
                        bookTitle: bookTitleCtrl.text.trim(),
                        bookAuthor: bookAuthorCtrl.text.trim(),
                        borrowDays: borrowDays,
                      );
                      Navigator.pop(context);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? '✅ Tạo phiếu thành công!'
                                : '❌ Mã phiếu đã tồn tại!',
                          ),
                          backgroundColor: ok ? kGreen : kRed,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Tạo phiếu mượn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1A3C5E)),
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A3C5E), width: 1.5),
          ),
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ---- Trả sách ----
  void _onReturnBook(BorrowRecord record) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.keyboard_return_rounded, color: Color(0xFF27AE60)),
            SizedBox(width: 10),
            Text('Xác nhận trả sách'),
          ],
        ),
        content: Text(
          'Xác nhận "${record.memberName}" đã trả\n"${record.bookTitle}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _listBorrow.returnBook(record.recordId);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Đã trả sách thành công!'),
                  backgroundColor: Color(0xFF27AE60),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  // ---- Gia hạn ----
  void _onExtend(BorrowRecord record) {
    int extraDays = 7;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState2) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.update_rounded, color: Color(0xFF1A3C5E)),
              SizedBox(width: 10),
              Text('Gia hạn mượn sách'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gia hạn thêm $extraDays ngày',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: extraDays.toDouble(),
                min: 3,
                max: 14,
                divisions: 11,
                activeColor: kNavy,
                onChanged: (v) => setState2(() => extraDays = v.round()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _listBorrow.extendRecord(record.recordId, days: extraDays);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ Đã gia hạn thêm $extraDays ngày!'),
                    backgroundColor: kNavy,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Gia hạn'),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Tìm kiếm ----
  void _showSearchDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tìm kiếm phiếu mượn'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nhập tên sách hoặc tên độc giả...',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kNavy,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              final keyword = ctrl.text.toLowerCase();
              final found = _listBorrow
                  .readAll()
                  .where(
                    (r) =>
                        r.bookTitle.toLowerCase().contains(keyword) ||
                        r.memberName.toLowerCase().contains(keyword),
                  )
                  .toList();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🔍 Tìm thấy ${found.length} phiếu mượn'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: kNavy,
                ),
              );
            },
            child: const Text('Tìm'),
          ),
        ],
      ),
    );
  }

  // ---- Format ngày ----
  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}
