import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/db/todo_db_provider.dart';
import 'package:todo/models/todo_model.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 14:24:53
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 14:25:03
///
class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> _todoList = [];
  List<Todo> _doneList = [];
  FocusNode? _focusNode = FocusNode();
  ScrollController? _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController!.addListener(() {
      if (_focusNode != null && _focusNode!.hasFocus) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

    Future.delayed(Duration.zero, () {
      _loadTodoList();
    });
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     print(visible);
    //   },
    // );
  }

  _loadTodoList() {
    TodoDbProvider provider = TodoDbProvider();
    provider.getTodos(null).then((value) {
      if (value != null) {
        _todoList.clear();
        _doneList.clear();
        for (Todo item in value.reversed) {
          if (item.status == 0) {
            _todoList.add(item);
          } else {
            _doneList.add(item);
          }
        }
        setState(() {
          _textEditingController.text = "";
        });
      }
    });
  }

  void _insertTodo(Todo todo) {
    TodoDbProvider provider = TodoDbProvider();
    provider.insert(todo).then((value) {
      _loadTodoList();
    });
  }

  void _updateTodoStatus(Todo todo) {
    TodoDbProvider provider = TodoDbProvider();
    provider.update(todo).then((value) {
      _loadTodoList();
    });
  }

  void _deleTodo(Todo todo) {
    TodoDbProvider provider = TodoDbProvider();
    provider.deleteTodo(todo.id!).then((value) {
      _loadTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            Positioned(
              left: 20,
              right: 20,
              top: 0,
              bottom: 60,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("待完成"),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 5);
                        },
                        controller: _scrollController,
                        itemCount: _todoList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _renderItem(_todoList[index]);
                        },
                      ),
                    ),
                    Text("已完成"),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 5);
                        },
                        controller: _scrollController,
                        itemCount: _doneList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _renderItem(_doneList[index], isDone: true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 0,
              height: 60,
              child: _renderInputHeader(),
            )
          ],
        )),
      ),
    );
  }

  _renderInputHeader() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 40,
      ),
      child: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        onSubmitted: (text) {
          if (text.length > 0) {
            Todo todo = Todo();
            todo.id = DateTime.now().millisecondsSinceEpoch;
            todo.addTime = DateTime.now().toString().split(".").first;
            todo.lastTime = DateTime.now().toString().split(".").first;
            todo.content = text;
            todo.status = 0;
            _insertTodo(todo);
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            prefixIcon: Icon(
              Icons.add,
              color: Color(0xffd1d1d1),
            ),
            fillColor: Theme.of(context).backgroundColor,
            filled: true,
            hintText: "添加...",
            hintStyle: TextStyle(color: Color(0xffd1d1d1), fontSize: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none)),
      ),
    );
  }

  _renderItem(Todo todo, {bool isDone = false}) {
    bool val = todo.status == 0 ? false : true;
    return Slidable(
        key: Key("key_${todo.id.toString()}"),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        dismissal: SlidableDismissal(
          onWillDismiss: (actionType) {
            if (actionType == SlideActionType.primary) {
              return false;
            } else {
              return true;
            }
          },
          // dismissThresholds: {SlideActionType.secondary : 220.0},
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            if (actionType == SlideActionType.secondary) {
              _deleTodo(todo);
            }
          },
        ),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Done',
            color: Colors.green,
            icon: Icons.done_outline,
            onTap: () {
              todo.status = todo.status == 0 ? 1 : 0;
              todo.lastTime = DateTime.now().toString().split(".").first;
              _updateTodoStatus(todo);
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            //onTap: () => removeLocation(location),
          ),
        ],
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: val,
                onChanged: (newValue) {
                  val = !val;
                  todo.status = val ? 1 : 0;
                  _updateTodoStatus(todo);
                },
              ),
              Text(
                todo.content ?? "",
                style: TextStyle(
                    color: isDone
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).accentColor,
                    fontSize: 18,
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _scrollController?.dispose();

    super.dispose();
  }
}
