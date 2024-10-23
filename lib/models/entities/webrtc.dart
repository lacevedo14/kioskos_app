import 'package:flutter/material.dart';

class CallState {
  final bool isCalling ;
  final String id;
  final Widget? widget;
  final int? networkLevel;

  CallState({
    required this.isCalling,
    required this.id,
    this.widget,
    this.networkLevel = 0,
  });

  static CallState copyWith({
    required bool isCalling,
    required String id,
    Widget? widget,
    int? networkLevel
  }) =>
      CallState(
        isCalling: isCalling,
        id: id,
        widget: widget,
        networkLevel: networkLevel,
      );
}
