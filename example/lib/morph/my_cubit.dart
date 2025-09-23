import 'package:bloc/bloc.dart';
import 'package:bloc_morph/core/morph_state.dart';
import 'package:meta/meta.dart';

part 'my_state.dart';

class MyCubit extends Cubit<MyState> {
  MyCubit() : super(MyDataState(typeState: TypeState.init));

}
