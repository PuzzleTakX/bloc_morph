import 'package:bloc/bloc.dart';
import 'package:bloc_morph/bloc_morph.dart';
import 'package:meta/meta.dart';

part 'my_state.dart';

class MyCubit extends Cubit<MyState> {
  MyCubit() : super(MyDataState(statusState: StatusState.init));
}
