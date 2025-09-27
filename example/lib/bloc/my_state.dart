part of 'my_bloc.dart';

@immutable
sealed class MyState implements MorphState {}

class DataInitial implements MyState {
  @override
  final String? requestKey;
  @override
  final StatusState statusState;
  @override
  final String? error;
  DataInitial({
    this.requestKey = "public_key",
    this.statusState = StatusState.init,
    this.error,
  });
}

class DataLoadState implements MyState {
  @override
  final String? requestKey;
  @override
  final StatusState statusState;
  @override
  final String? error;
  final List<DataWallPaper>? data;

  DataLoadState({
    this.requestKey,
    required this.statusState,
    this.error,
    this.data,
  });
}

class DataLoadStatePage implements MyState {
  @override
  final String? requestKey;
  @override
  final StatusState statusState;
  @override
  final String? error;

  final int page;

  /// This is completely mandatory

  final List<DataWallPaper>? data;

  DataLoadStatePage({
    this.requestKey,
    required this.statusState,
    this.error,
    required this.page,
    this.data,
  });
}
