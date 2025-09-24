part of 'my_bloc.dart';

@immutable
sealed class MyEvent {}

class FetchDataEvent extends MyEvent {
  final String? key;
  FetchDataEvent({this.key = "public_key"});
}
