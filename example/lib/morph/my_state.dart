part of 'my_cubit.dart';

@immutable
sealed class MyState implements MorphState{

}
class MyDataState extends MyState {
  @override
  final String? error;

  @override
  final String? requestKey;

  @override
  final TypeState typeState;

  MyDataState({this.error,required this.typeState,this.requestKey});
}
