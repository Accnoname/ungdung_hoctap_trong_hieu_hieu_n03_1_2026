class DataWrapper<T> {
  T obj;

  DataWrapper(this.obj);

  void displayData() {
    print('Data: $obj');
    print('Kind of Data: ${obj.runtimeType}');
  }
}

void main(){
  var student = [
    {"Student ID": "s123456", "fullname":'Nguyen Thi B'},
    {"Student ID": "s345672", "fullname":'Nguyen Van D'},
    {"Student ID": "s923333", "fullname":'Tran Thi Van'},
  ];

  var wrapper = DataWrapper<List<Map<String, String>>>(student);
  wrapper.displayData();
}