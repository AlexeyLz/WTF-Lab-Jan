import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class PropertyMessage {
  final int id;
  final bool isSelected;
  final IconData icon;
  final String data;
  final DateTime time;
  final int idMessagePage;
  final bool isBookmark;
  final bool isVisible;

  PropertyMessage({
    this.id,
    this.idMessagePage,
    this.data,
    this.time,
    this.isSelected = false,
    this.icon,
    this.isBookmark = false,
    this.isVisible = true,
  });

  Widget get message;

  PropertyMessage copyWith({
    final int id,
    final int idMessagePage,
    final String data,
    final DateTime time,
    final bool isSelected,
    final IconData icon,
    final bool isBookmark,
    final bool isVisible,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'time': DateFormat('yyyy-MM-dd – HH:mm').format(time),
      'icon_code_point_message': icon == null ? null : icon.codePoint,
      'id_message_page': idMessagePage,
      'is_selected': isSelected ? 1 : 0,
      'is_bookmark': isBookmark ? 1 : 0,
      'is_visible': isVisible ? 1 : 0,
    };
  }

  factory PropertyMessage.fromMap(Map<String, dynamic> map) {
    return TextMessage(
      id: map['id'],
      data: map['data'],
      time: DateFormat('yyyy-MM-dd – HH:mm').parse(map['time']),
      icon: map['icon_code_point_message'] == null
          ? null
          : IconData(map['icon_code_point_message'],
              fontFamily: 'MaterialIcons'),
      idMessagePage: map['id_message_page'],
      isSelected: map['is_selected'] == 1 ? true : false,
      isBookmark: map['is_bookmark'] == 1 ? true : false,
      isVisible: map['is_visible'] == 1 ? true : false,
    );
  }
}

class TextMessage extends PropertyMessage {
  TextMessage({
    int id,
    bool isSelected,
    IconData icon,
    String data,
    DateTime time,
    int idMessagePage,
    bool isBookmark,
    bool isVisible,
  }) : super(
          id: id,
          isSelected: isSelected,
          icon: icon,
          data: data,
          time: time,
          idMessagePage: idMessagePage,
          isBookmark: isBookmark,
          isVisible: isVisible,
  );

  @override
  PropertyMessage copyWith({
    final int id,
    final bool isSelected,
    final IconData icon,
    final String data,
    final DateTime time,
    final int idMessagePage,
    final bool isBookmark,
    final bool isVisible,
  }) {
    return TextMessage(
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
      data: data ?? this.data,
      time: time ?? this.time,
      idMessagePage: idMessagePage ?? this.idMessagePage,
      isBookmark: isBookmark ?? this.isBookmark,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Widget get message => Text(data);
}

class ImageMessage extends PropertyMessage {
  ImageMessage({
    int id,
    bool isSelected,
    IconData icon,
    String data,
    DateTime time,
    int idMessagePage,
    bool isBookmark,
    bool isVisible,
  }) : super(
          id: id,
          isSelected: isSelected,
          icon: icon,
          data: data,
          time: time,
          idMessagePage: idMessagePage,
          isBookmark: isBookmark,
          isVisible: isVisible,
  );

  @override
  PropertyMessage copyWith({
    final int id,
    final bool isSelected,
    final IconData icon,
    final String data,
    final DateTime time,
    final int idMessagePage,
    final bool isBookmark,
    final bool isVisible,
  }) {
    return TextMessage(
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
      data: data ?? this.data,
      time: time ?? this.time,
      idMessagePage: idMessagePage ?? this.idMessagePage,
      isBookmark: isBookmark ?? this.isBookmark,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Widget get message => Image.file(File(data));
}
