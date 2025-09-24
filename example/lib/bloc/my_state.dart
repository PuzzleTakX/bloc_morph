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
  final List<ImageItem>? data;
  DataInitial({
    this.requestKey = "public_key",
    this.statusState = StatusState.init,
    this.error,
    this.data,
  });
}
class DataLoadState implements MyState {
  @override
  final String? requestKey;
  @override
  final StatusState statusState;
  @override
  final String? error;
  final List<ImageItem>? data;

  DataLoadState({
    this.requestKey = "public_key",
    required this.statusState,
    this.error,
    this.data,
  });
}