import 'package:bloc/bloc.dart';
import 'package:bloc_morph/bloc_morph.dart';
import 'package:dio/dio.dart';
import 'package:example/bloc/model_wallpaper.dart';
import 'package:meta/meta.dart';

part 'my_event.dart';
part 'my_state.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(DataInitial()) {
    on<FetchWallpapersEvent>(_onFetchWallpapers);
    on<FetchWallpapersPaginationEvent>(_onFetchWallpapersPage);
  }

  void _onFetchWallpapers(
    FetchWallpapersEvent event,
    Emitter<MyState> emit,
  ) async {
    emit(
      DataLoadState(statusState: StatusState.loading, requestKey: event.key),
    );
    try {
      final dio = Dio();
      final response = await dio.get('https://peapix.com/bing/feed');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isEmpty) {
          emit(
            DataLoadState(
              statusState: StatusState.empty,
              requestKey: event.key,
            ),
          );
        } else {
          final List<DataWallPaper> images =
              data.map((item) {
                return DataWallPaper.fromJson(item);
              }).toList();
          emit(
            DataLoadState(
              data: images,
              requestKey: event.key,
              statusState: StatusState.next,
            ),
          );
        }
      } else {
        emit(
          DataLoadState(
            error: "Failed to load wallpapers",
            statusState: StatusState.error,
            requestKey: event.key,
          ),
        );
      }
    } catch (e) {
      emit(
        DataLoadState(
          error: e.toString(),
          statusState: StatusState.networkError,
          requestKey: event.key,
        ),
      );
    }
  }

  void _onFetchWallpapersPage(
    FetchWallpapersPaginationEvent event,
    Emitter<MyState> emit,
  ) async {
    emit(
      DataLoadStatePage(
        statusState: StatusState.loading,
        requestKey: event.key,
        page: event.page,
      ),
    );
    try {
      final dio = Dio();
      final response = await dio.get('https://peapix.com/bing/feed');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isEmpty) {
          emit(
            DataLoadStatePage(
              statusState: StatusState.empty,
              requestKey: event.key,
              page: event.page,
            ),
          );
        } else {
          final List<DataWallPaper> images =
              data.map((item) {
                return DataWallPaper.fromJson(item);
              }).toList();
          emit(
            DataLoadStatePage(
              data: images,
              requestKey: event.key,
              page: event.page,
              statusState: StatusState.next,
            ),
          );
        }
      } else {
        emit(
          DataLoadStatePage(
            error: "Failed to load wallpapers",
            statusState: StatusState.error,
            requestKey: event.key,
            page: event.page,
          ),
        );
      }
    } catch (e) {
      emit(
        DataLoadStatePage(
          error: e.toString(),
          statusState: StatusState.networkError,
          requestKey: event.key,
          page: event.page,
        ),
      );
    }
  }

  void fetchWallpapers() => add(FetchWallpapersEvent());
  void fetchWallpapersWithKey(String key) =>
      add(FetchWallpapersEvent(key: key));
  void fetchWallpapersPagination(int page) =>
      add(FetchWallpapersPaginationEvent(page: page));
}
