part of 'bloc_cubit.dart';

@immutable
sealed class BlocState implements MorphState {}

class BlocInitial extends BlocState {
  @override
  final String? error;

  @override
  final String? requestKey;

  @override
  final TypeState typeState;

  BlocInitial({this.error, this.requestKey, this.typeState = TypeState.init});
}

class BlocDataState extends BlocState {
  @override
  final String? error;

  @override
  final String? requestKey;

  @override
  final TypeState typeState;
  final List<ImageItem>? data;

  BlocDataState({
    this.error,
    this.requestKey,
    required this.typeState,
    this.data,
  });
}
