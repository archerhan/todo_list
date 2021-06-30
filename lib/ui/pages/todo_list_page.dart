import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/app_strings.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/providers/todo_provider.dart';

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
  TodoProvider _todoProvider = TodoProvider();
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

    _loadData();
  }

  void _loadData() async {
    await _todoProvider.fetchData();
  }

  void _cleanInput() {
    _textEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            body: ChangeNotifierProvider<TodoProvider>(
          create: (ctx) => _todoProvider,
          child: Consumer<TodoProvider>(
            builder: (_, todoProvider, __) {
              return _content();
            },
          ),
        )),
      ),
    );
  }

  Widget _content() {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 20,
          right: 20,
          top: 0,
          bottom: 60,
          child: _todoListView(),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 0,
          height: 60,
          child: _renderInputHeader(),
        )
      ],
    );
  }

  Widget _todoListView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.thingsTodo),
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeTop: true,
            child: _todoProvider.todoList.length == 0
                ? Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(AppStrings.addTodoBelow),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 5);
                    },
                    controller: _scrollController,
                    itemCount: _todoProvider.todoList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _renderItem(_todoProvider.todoList[index]);
                    },
                  ),
          ),
          Text(AppStrings.thingsDone),
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeTop: true,
            child: _todoProvider.doneList.length == 0
                ? Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(AppStrings.doneEmpty),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 5);
                    },
                    controller: _scrollController,
                    itemCount: _todoProvider.doneList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _renderItem(_todoProvider.doneList[index],
                          isDone: true);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _renderInputHeader() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 40,
      ),
      child: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        onSubmitted: (text) async {
          if (text.length > 0) {
            Todo todo = Todo();
            todo.id = DateTime.now().millisecondsSinceEpoch;
            todo.addTime = DateTime.now().toString().split(".").first;
            todo.lastTime = DateTime.now().toString().split(".").first;
            todo.content = text;
            todo.status = 0;
            _cleanInput();
            await _todoProvider.insertTodo(todo);
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            prefixIcon: Icon(
              Icons.add,
              color: Color(0xffffffff),
            ),
            fillColor: Theme.of(context).backgroundColor,
            filled: true,
            hintText: AppStrings.addTodo,
            hintStyle: TextStyle(color: Color(0xffffffff), fontSize: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _renderItem(Todo todo, {bool isDone = false}) {
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
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) async {
            if (actionType == SlideActionType.secondary) {
              await _todoProvider.deleteTodo(todo);
            }
          },
        ),
        actions: <Widget>[
          IconSlideAction(
            caption: AppStrings.acomplish,
            color: Colors.green,
            icon: Icons.done_outline,
            onTap: () async {
              todo.status = todo.status == 0 ? 1 : 0;
              todo.lastTime = DateTime.now().toString().split(".").first;
              _todoProvider.updateTodo(todo);
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: AppStrings.deleteTodo,
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              await _todoProvider.deleteTodo(todo);
            },
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
                onChanged: (newValue) async {
                  val = !val;
                  todo.status = val ? 1 : 0;
                  await _todoProvider.updateTodo(todo);
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
