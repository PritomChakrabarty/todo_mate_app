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

  void _showEditDialog(
      BuildContext context, Map<String, dynamic> todo, int filter) {
    TextEditingController titleController =
        TextEditingController(text: todo["t_title"]);
    TextEditingController descController =
        TextEditingController(text: todo["t_desc"]);
    int priority = todo["t_priority"];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Edit Todo"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: priority,
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    Text("Low"),
                    Radio<int>(
                      value: 2,
                      groupValue: priority,
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    Text("Medium"),
                    Radio<int>(
                      value: 3,
                      groupValue: priority,
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    Text("High"),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DbProvider>().updateTodo(
                      id: todo["t_id"],
                      title: titleController.text,
                      desc: descController.text,
                      priority: priority,
                      filter: filter,
                    );
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int id, int filter) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this todo?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                context.read<DbProvider>().deleteTodo(id: id, filter: filter);
                Navigator.pop(context); // Close dialog
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
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
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        filter = 0;
                        // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos();
                        context
                            .read<DbProvider>()
                            .fetchInitialTodos(filter: filter);
                      },
                      child: Text("All"))),
              SizedBox(
                width: 11,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        filter = 1;
                        // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos(filter: filter);
                        context
                            .read<DbProvider>()
                            .fetchInitialTodos(filter: filter);
                      },
                      child: Text("Completed"))),
              SizedBox(
                width: 11,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        filter = 2;
                        // Provider.of<DbProvider>(context, listen: false).fetchInitialTodos(filter: filter);
                        context
                            .read<DbProvider>()
                            .fetchInitialTodos(filter: filter);
                      },
                      child: Text("Pending"))),
            ],
          ),
          Consumer<DbProvider>(builder: (_, provider, __) {
            mTodo = provider.getData();
            return Expanded(
              child: mTodo.isNotEmpty
                  ? ListView.builder(
                      itemCount: mTodo.length,
                      itemBuilder: (_, index) {
                        Color bgColor = Colors.grey.shade200;

                        if (mTodo[index]["t_priority"] == 1) {
                          bgColor = Colors.grey.shade200;
                        } else if (mTodo[index]["t_priority"] == 2) {
                          bgColor = Colors.yellow.shade200;
                        } else if (mTodo[index]["t_priority"] == 3) {
                          bgColor = Colors.red.shade200;
                        }

                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          child: ListTile(
                            tileColor: bgColor,
                            title: Text(
                              mTodo[index]["t_title"],
                              style: TextStyle(
                                decoration: mTodo[index]["t_isCompleted"] == 1
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              mTodo[index]["t_desc"],
                              style: TextStyle(
                                decoration: mTodo[index]["t_isCompleted"] == 1
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            leading: Checkbox(
                              value: mTodo[index]["t_isCompleted"] == 1,
                              onChanged: (value) {
                                context.read<DbProvider>().isCompleted(
                                      id: mTodo[index]["t_id"],
                                      isCompleted: value!,
                                      filter: filter,
                                    );
                              },
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showEditDialog(
                                        context, mTodo[index], filter);
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteDialog(
                                        context, mTodo[index]["t_id"], filter);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text("No Todo"),
                    ),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTodoPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
