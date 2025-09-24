part of 'bloc_cubit.dart';

@immutable
sealed class BlocState implements MorphState {}

class BlocInitial extends BlocState {
  @override
  final String? error;

  @override
  final String? requestKey;

  @override
  final StatusState statusState;

  BlocInitial({this.error, this.requestKey, this.statusState = StatusState.init});
}

class BlocDataState extends BlocState {
  @override
  final String? error;

  @override
  final String? requestKey;

  @override
  final StatusState statusState;
  final List<ImageItem>? data;

  BlocDataState({
    this.error,
    this.requestKey,
    required this.statusState,
    this.data,
  });
}
