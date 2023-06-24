import 'package:flutter/material.dart';

@immutable
class ApplicationPageState {
  final bool isDarkTheme;
  final bool isOfflineMode;

  const ApplicationPageState({
    required this.isDarkTheme,
    required this.isOfflineMode,
  });

  ApplicationPageState copyWith({
    bool? isDarkTheme,
    bool? isOfflineMode,
  }) {
    return ApplicationPageState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}
