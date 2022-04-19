import 'package:get/get.dart';
import 'package:todoapp/models/database.dart';
import 'package:todoapp/models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DB.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DB.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DB.delete(task);
  }

}