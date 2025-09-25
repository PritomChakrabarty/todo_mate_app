import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mate/add_todo_page.dart';
import 'package:todo_mate/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> mTodo = [];
  int filter = 0;

  @override
  void initState() {
    super.initState();
    // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos();
    context.read<DbProvider>().fetchInitialTodos();
  }

  @override
  Widget build(BuildContext context) {

    // mTodo = Provider.of<DbProvider>(context).getData();
    // mTodo = context.watch<DbProvider>().getData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: (){
                filter = 0;
                // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos();
                context.read<DbProvider>().fetchInitialTodos(filter: filter);
              }, child: Text("All"))),
              SizedBox(width: 11,),
              Expanded(child: ElevatedButton(onPressed: (){
                filter = 1;
                // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos(filter: filter);
                context.read<DbProvider>().fetchInitialTodos(filter: filter);
              }, child: Text("Completed"))),
              SizedBox(width: 11,),
              Expanded(child: ElevatedButton(onPressed: (){
                filter = 2;
                // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos(filter: filter);
                context.read<DbProvider>().fetchInitialTodos(filter: filter);
              }, child: Text("Pending"))),
            ],
          ),
          Consumer<DbProvider>(
            builder: (_, provider, __){
              mTodo = provider.getData();
              return Expanded(
            child: mTodo.isNotEmpty ? ListView.builder(
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
                // Provider.of<DbProvider>(context).isCompleted(id: mTodo[index]["t_id"], isCompleted: value!, filter: filter);
                context.read<DbProvider>().isCompleted(id: mTodo[index]["t_id"], isCompleted: value!, filter: filter);
              });
                  }) : Center(
                    child: Text("No Todo"),
                  ),
          );
            } 
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoPage()));
      },child: Icon(Icons.add),
      ),
    );
  }
}