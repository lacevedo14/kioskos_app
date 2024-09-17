import 'package:flutter/material.dart';

class CallState {
  final bool isCalling;
  final String id;
  final Widget? widget;

  CallState({
    required this.isCalling,
    required this.id,
    this.widget,
  });

  static CallState copyWith({
    required bool isCalling,
    required String id,
    Widget? widget,
  }) =>
      CallState(
        isCalling: isCalling,
        id: id,
        widget: widget,
      );
}
