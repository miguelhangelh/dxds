
import 'package:hive/hive.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
class TasksLocalDB {
  
  static final TasksLocalDB _instancia = new TasksLocalDB._();

  factory TasksLocalDB() {
    return _instancia;
  }

  TasksLocalDB._();

  Box<TaskLocal>? _dbTask;

  Box<TaskLocal>? get dbTaskLocal => _dbTask;

  initHiveDB() async {
    try {
      _dbTask = await Hive.openBox<TaskLocal>('tasksLocal');
    }catch (e){
      print("TASK LOCAL DB ERROR $e");
      Hive.deleteBoxFromDisk("tasksLocal");
    }
  }

  Box<TaskLocal>? getTasks() {
    return _dbTask;
  }

  addTasks(TaskLocal task) {
    _dbTask!.add(task);
  }

  updateTask(int index, TaskLocal tasks) {
    _dbTask!.putAt(index, tasks);
  }
  updateTaskState( TaskLocal tasks) {
    tasks.state = 1;
    tasks.file = tasks.file;
    tasks.comment = tasks.comment;
    tasks.save();
  }

  Future<void> deleteTask(int index) async {
    await _dbTask!.deleteAt(index);
  }

  deleteTaskKey(key) {
    _dbTask!.delete(key);
  }
}
