part of 'my_bloc.dart';

@immutable
sealed class MyState implements MorphState {
  @override
  String? get requestKey;
  @override
  TypeState get typeState;
  @override
  String? get error;
}
class DataInitial implements MyState {
  @override
  final String? requestKey;
  @override
  final TypeState typeState;
  @override
  final String? error;
  final List<ImageItem>? data;
  DataInitial({
    this.requestKey = "public_key",
    this.typeState = TypeState.init,
    this.error,
    this.data,
  });
}
class DataLoadState implements MyState {
  @override
  final String? requestKey;
  @override
  final TypeState typeState;
  @override
  final String? error;
  final List<ImageItem>? data;

  DataLoadState({
    this.requestKey = "public_key",
    required this.typeState,
    this.error,
    this.data,
  });
}