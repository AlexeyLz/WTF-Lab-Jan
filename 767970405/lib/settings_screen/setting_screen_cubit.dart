import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/constans/constans.dart';

part 'setting_screen_state.dart';

class SettingScreenCubit extends Cubit<SettingScreenState> {
  SettingScreenCubit({
    int index,
  }) : super(SettingScreenState()) {
    emit(index == 0 ? darkTheme : lightTheme);
  }

  SettingScreenState get lightTheme => state.copyWith(
        titleColor: Colors.black,
        bodyColor: Colors.black.withOpacity(0.4),
        botIconColor: Colors.black,
        botBackgroundColor: Colors.green[50],
        categoryBackgroundColor: Colors.teal[200],
        categoryIconColor: Colors.white,
        messageUnselectedColor: Colors.green[50],
        messageSelectedColor: Colors.green[200],
        dateTimeModeButtonBackgroundColor: Colors.red[50],
        dateTimeModeButtonIconColor: Colors.white,
        labelDateBackgroundColor: Colors.red,
        helpWindowBackgroundColor: Colors.green[50],
        appBrightness: Brightness.light,
        appPrimaryColor: Colors.teal,
      );

  SettingScreenState get darkTheme => state.copyWith(
        titleColor: Colors.white,
        bodyColor: Colors.white,
        botIconColor: Colors.white,
        botBackgroundColor: Colors.black,
        categoryBackgroundColor: Colors.teal[200],
        categoryIconColor: Colors.white,
        messageUnselectedColor: Colors.black,
        messageSelectedColor: Colors.orangeAccent,
        dateTimeModeButtonBackgroundColor: Colors.red[50],
        dateTimeModeButtonIconColor: Colors.white,
        labelDateBackgroundColor: Colors.red,
        helpWindowBackgroundColor: Colors.black,
        appBrightness: Brightness.dark,
        appPrimaryColor: Colors.black,
      );

  void toggleTheme() {
    if (state.appBrightness == Brightness.dark) {
      emit(lightTheme);
    } else if (state.appBrightness == Brightness.light) {
      emit(darkTheme);
    }
  }

  void changeFontSize(TypeFontSize typeFontSize) {
    switch (typeFontSize) {
      case TypeFontSize.small:
        emit(
          state.copyWith(
            titleFontSize: DefaultFontSize.titleText * kSmall,
            bodyFontSize: DefaultFontSize.bodyText * kSmall,
            appBarTitleFontSize: DefaultFontSize.appBarTitle * kSmall,
            floatingWindowFontSize: DefaultFontSize.floatingWindowText * kSmall,
          ),
        );
        break;
      case TypeFontSize.def:
        emit(
          state.copyWith(
            titleFontSize: DefaultFontSize.titleText,
            bodyFontSize: DefaultFontSize.bodyText,
            appBarTitleFontSize: DefaultFontSize.appBarTitle,
            floatingWindowFontSize: DefaultFontSize.floatingWindowText,
          ),
        );
        break;
      case TypeFontSize.large:
        emit(
          state.copyWith(
            titleFontSize: DefaultFontSize.titleText * kLarge,
            bodyFontSize: DefaultFontSize.bodyText * kLarge,
            appBarTitleFontSize: DefaultFontSize.appBarTitle * kLarge,
            floatingWindowFontSize: DefaultFontSize.floatingWindowText * kLarge,
          ),
        );
        break;
    }
  }

  void resetSettings() {
    emit(
      lightTheme.copyWith(
        titleFontSize: DefaultFontSize.titleText,
        bodyFontSize: DefaultFontSize.bodyText,
        appBarTitleFontSize: DefaultFontSize.appBarTitle,
        floatingWindowFontSize: DefaultFontSize.floatingWindowText,
        appAccentColor: Colors.amberAccent,
        appFontFamily: 'Roboto',
      ),
    );
  }

  void changeBubbleAlign(bool value) {
    emit(state.copyWith(isLeftBubbleAlign: value));
  }

  void changeDateTimeModification(bool value) {
    emit(state.copyWith(isDateTimeModification: value));
  }

  void changeCenterDateBubble(bool value) {
    emit(state.copyWith(isCenterDateBubble: value));
  }

  void changeAuthentication(bool value) {
    emit(state.copyWith(isAuthentication: value));
  }

  void pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    emit(state.copyWith(pathBackgroundImage: pickedFile.path));
  }

  void unsetImage() {
    emit(state.copyWith(pathBackgroundImage: ''));
  }
}
