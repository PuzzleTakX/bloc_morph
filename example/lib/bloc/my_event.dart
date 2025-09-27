part of 'my_bloc.dart';

@immutable
sealed class MyEvent {}

class FetchDataEvent extends MyEvent {
  final String? key;
  FetchDataEvent({this.key = "public_key"});
}

class FetchWallpapersEvent extends MyEvent {
  final String? key;
  FetchWallpapersEvent({this.key});
}

class FetchWallpapersPaginationEvent extends MyEvent {
  final String? key;
  final int page;
  FetchWallpapersPaginationEvent({this.key, required this.page});
}
