import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeEvent { toggle }

class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: false)) {
    on<ThemeEvent>((event, emit) {
      if (event == ThemeEvent.toggle) {
        emit(ThemeState(isDarkMode: !state.isDarkMode));
      }
    });
  }
}
