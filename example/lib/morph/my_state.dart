part of 'my_cubit.dart';

@immutable
sealed class MyState implements MorphState {}

class MyDataState extends MyState {
  @override
  final String? error;

  @override
  final String? requestKey;

  @override
  final StatusState statusState;

  MyDataState({this.error, required this.statusState, this.requestKey});
}
