import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mate/db_helper.dart';
import 'package:todo_mate/db_provider.dart';

class AddTodoPage extends StatefulWidget {
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  var titleController = TextEditingController();

  var descController = TextEditingController();

  int priority = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  hintText: "Enter Title",
                  label: Text("Title"),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21))),
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: descController,
              maxLines: 4,
              minLines: 4,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: "Enter Description",
                  label: Text("Description"),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21))),
            ),
            SizedBox(
              height: 11,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RadioMenuButton(
                    value: 1,
                    groupValue: priority,
                    onChanged: (value) {
                      priority = value!;
                      setState(() {});
                    },
                    child: Text("Low")),
                RadioMenuButton(
                    value: 2,
                    groupValue: priority,
                    onChanged: (value) {
                      priority = value!;
                      setState(() {});
                    },
                    child: Text("Medium")),
                RadioMenuButton(
                    value: 3,
                    groupValue: priority,
                    onChanged: (value) {
                      priority = value!;
                      setState(() {});
                    },
                    child: Text("High")),
              ],
            ),
            SizedBox(
              height: 11,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      // Provider.of<DbProvider>(context, listen: false).addTodo(title: titleController.text, desc: descController.text, priority: priority);
                      context.read<DbProvider>().addTodo(title: titleController.text, desc: descController.text, priority: priority);
                      Navigator.pop(context);
                    },
                    child: Text("Add"))),
          ],
        ),
      ),
    );
  }
}
