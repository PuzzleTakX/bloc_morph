import 'package:bloc/bloc.dart';
import 'package:bloc_morph/core/morph_state.dart';
import 'package:example/bloc/item_image.dart';
import 'package:meta/meta.dart';

part 'bloc_state.dart';

class BlocCubit extends Cubit<BlocState> {
  BlocCubit() : super(BlocInitial());

  void fetchData({String key = "public_key"}) async {
    emit(BlocDataState(requestKey: key, statusState: StatusState.loading));
    await Future.delayed(const Duration(seconds: 2));

    final random = DateTime.now().second % 4;
    if (random == 0) {
      final List<ImageItem> images = [
        ImageItem(
          imageUrl:
              "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-169994-674010.jpg&fm=jpg",
          title: "Beautiful Landscape 1",
          description: "A serene view of mountains during sunrise.",
        ),
        ImageItem(
          imageUrl:
              "https://plus.unsplash.com/premium_photo-1710965560034-778eedc929ff?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YmVhdXRpZnVsJTIwd29ybGR8ZW58MHx8MHx8fDA%3D",
          title: "Majestic World",
          description: "A breathtaking scenery capturing nature's beauty.",
        ),
        ImageItem(
          imageUrl:
              "https://images.pexels.com/photos/1887624/pexels-photo-1887624.jpeg?cs=srgb&dl=pexels-tobiasbjorkli-1887624.jpg&fm=jpg",
          title: "Mountain Adventure",
          description: "Exploring the wild mountains with a clear sky.",
        ),
        ImageItem(
          imageUrl:
              "https://t4.ftcdn.net/jpg/07/41/71/93/360_F_741719394_C9BP3YbiXSJ7WspSDLtKdYxZKKWlf0Jz.jpg",
          title: "Sunset Glow",
          description: "Golden hues of sunset reflecting on the water.",
        ),
        ImageItem(
          imageUrl:
              "https://i.pinimg.com/736x/34/df/66/34df66ed4b966802eaaaaa09d0cd6d66.jpg",
          title: "City Lights",
          description: "Vibrant lights of the city at night.",
        ),
      ];
      emit(
        BlocDataState(data: images, requestKey: key, statusState: StatusState.next),
      );
    } else if (random == 1) {
      emit(BlocDataState(requestKey: key, statusState: StatusState.empty));
    } else if (random == 2) {
      emit(BlocDataState(requestKey: key, statusState: StatusState.error));
    } else {
      emit(BlocDataState(requestKey: key, statusState: StatusState.networkError));
    }
  }
}


