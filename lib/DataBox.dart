
class DataBox<T> {
  T obj;
  DataBox(this.obj);

  void display() {
    print(obj);
  }
}

void main() {

  var student = [
    {'studentID': 's123456', 'fullname': 'Nguyen Thi B'},
    {'studentID': 's345672', 'fullname': 'Nguyen Van D'},
    {'studentID': 's923333', 'fullname': 'Tran Thi Van'},
  ];


  var box = DataBox<List<Map<String, String>>>(student);

  print("--- Dữ liệu sinh viên ---");
  box.obj.forEach((s) {
    print("ID: ${s['studentID']} - Tên: ${s['fullname']}");
  });
}