import 'package:flutter/material.dart';
import 'package:basic_todo_app/task.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'All';
  List<Task>  getFilteredTasks() {
    if (selectedFilter == 'Active') {
      return tasks.where((task) => task.isCompleted == false).toList();
    } else if (selectedFilter == 'Done') {
      return tasks.where((task) => task.isCompleted == true).toList();
    }
    return tasks;
  }
  List<Task> tasks = [];
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', taskList);
  }
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = taskList.map((task) => Task.fromJson(jsonDecode(task))).toList();
    });
  }
  TextEditingController taskController = TextEditingController();
  TimeOfDay? selectedTime ;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        title:Text('Daily Tasks App',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(30), 
        child: Padding(padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
          style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ),
        ),
        actions: [
          IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // Navigate to stats screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatsScreen(
                    doneCount: tasks.where((t) => t.isCompleted).length,
                    pendingCount: tasks.where((t) => !t.isCompleted).length,
                    totalCount: tasks.length,
                  )
                )
              );
            }
          )
        ]
      ),
      body: Container(
        color: const Color(0xFFf5f3ff),
        child:
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:['All', 'Active', 'Done'].map((filter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedFilter == filter 
                    ? Colors.lightBlueAccent
                    : Colors.grey.shade200,
                  ),
                    child: Text(filter,
                    style: TextStyle(
                      color: selectedFilter == filter 
                      ? Colors.white
                      : Colors.black,
                    ),
                  ),
                 
                ),
              );
            }).toList(),
          ),
       Expanded (
        child: tasks.isEmpty 
      ?const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add a new task',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        )
      )
      :ListView.builder(
        itemCount: getFilteredTasks().length,
        itemBuilder:(context, index) {
          final task = getFilteredTasks()[index];
          return Dismissible(
            key: Key(task.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
              saveTasks();
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
              ),
            ),
            subtitle: task.time != null 
            ? Text(task.time!.format(context))
            : const Text('No time set'),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged:(value) {
                setState(() {
                  task.isCompleted = !task.isCompleted;
                });
                saveTasks();
              },

          ),
          ),
        ),
      );
        },
        ),

       ),
      ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
           showModalBottomSheet( 
          context: context,
          builder:(context) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add New Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold, 
                    ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        labelText: 'Task name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height:16),
                    ElevatedButton.icon(
                      onPressed:()async{
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if(pickedTime != null){
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: const Text('Pick Time'),
                    ),
                    const SizedBox(height:16),
                    ElevatedButton(
                      onPressed:(){
                        if(taskController.text.isNotEmpty){
                          setState(() {
                            tasks.add(Task(
                              title: taskController.text,
                              time: selectedTime,
                            ));
                            saveTasks();
                          });
                          taskController.clear();
                          selectedTime = null;
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add Task'),
                    ), 
                ],
              ),
              );
          },
        );
        },
        backgroundColor: const Color(0xFF6d5acd),
        child: const Icon(Icons.add, color: Colors.white,),
      )
    );
  }
}