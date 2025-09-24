import 'package:flutter/material.dart';
import 'package:todo_mate/db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper? dbHelper;
  List<Map<String, dynamic>> mTodo = [];

  @override
  void initState() {
    super.initState();

    dbHelper = DbHelper.getInstance();
    getTodos();
  }

  void getTodos() async{
    mTodo = await dbHelper!.fetchAllTodo();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: mTodo.isNotEmpty ? ListView.builder(
        itemCount: mTodo.length,
        itemBuilder: (_, index) {
          Color bgColor = Colors.grey.shade200;

          if(mTodo[index]["t_priority"] == 1) {
            bgColor = Colors.grey.shade200;
          } else if(mTodo[index]["t_priority"] == 2) {
            bgColor = Colors.yellow.shade200;
          } else if(mTodo[index]["t_priority"] == 3) {
            bgColor = Colors.red.shade200;
          }

          return CheckboxListTile(
            tileColor : bgColor,
            title: Text(mTodo[index]["t_title"], style: TextStyle(
              decoration: mTodo[index]["t_isCompleted"] == 1 ? TextDecoration.lineThrough : TextDecoration.none
            ),),
            subtitle: Text(mTodo[index]["t_desc"], style: TextStyle(
              decoration: mTodo[index]["t_isCompleted"] == 1 ? TextDecoration.lineThrough : TextDecoration.none
            ),),
            value: mTodo[index]["t_isCompleted"] == 1, 
            onChanged: (value) async {
              bool check = await dbHelper!.updateTodoCompleted(id: mTodo[index]["t_id"], isCompleted: value!);
              if(check){
                getTodos();
              }
            });
      }) : Center(
        child: Text("No Todo"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        bool check = await dbHelper!.addTodo(
          title: "My Check List", 
          desc: "DB with Provider",
          priority: 2
          );

        if(check){
          getTodos();
        }
      },child: Icon(Icons.add),
      ),
    );
  }
}