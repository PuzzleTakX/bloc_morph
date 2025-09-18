part of 'bloc_cubit.dart';

@immutable
sealed class BlocState {}

final class BlocInitial extends BlocState {}
final class BlocSampleState extends BlocState {
  final TypeState typeState;
  final String? msg;
  final List<ImageItem>? data; // your data
  BlocSampleState({required this.typeState,this.data,this.msg});
}
final class BlocSampleWithRequestKeyState extends BlocState {
  final TypeState typeState;
  final String requestKey;
  final String? msg;
  final List<ImageItem>? data; // your data
  BlocSampleWithRequestKeyState({required this.typeState,this.data,this.msg,required this.requestKey});
}
