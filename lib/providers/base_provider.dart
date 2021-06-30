import 'package:flutter/material.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 23:02:06
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 23:03:50
///
enum PageState {
  loading, //加载中
  hasData, //有数据
  empty, //无数据
  error, //加载失败
}
class BaseProvider extends ChangeNotifier {
  PageState pageState = PageState.loading;
  bool _isDispose = false;
  var errorMessage;

  bool get isDispose => _isDispose;

  @override
  void notifyListeners() {
    print("view model notifyListeners");
    if (!_isDispose) {
      super.notifyListeners();
    }
  }

  errorNotify(String error) {
    pageState = PageState.error;
    errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDispose = true;
    print("view model dispose");
    super.dispose();
  }
}

