import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// MorphSelector<T>
/// ---------------------------
/// A StatefulWidget that listens to a Bloc but rebuilds **only**
/// when the Bloc emits a state of type [T]. Other states are ignored,
/// keeping the previous data intact.
///
/// You can optionally provide an [initial] value to display before
/// receiving a state from the Bloc. If no initial value is provided,
/// [placeholder] widget is shown until a state of type [T] arrives.
///
/// Example usage:
/// ```dart
/// MorphSelector<MyBloc, MyState, StateData>(
///   initial: StateData([]),
///   placeholder: Center(child: Text('Loading...')),
///   builder: (context, bloc, state, data) {
///     return ListView(
///       children: data.items.map((e) => Text(e)).toList(),
///     );
///   },
/// )
/// ```
class MorphSelector<B extends StateStreamable<S>, S, T> extends StatefulWidget {
  /// Builder function that receives the Bloc, the full state,
  /// and the selected value of type [T].
  final Widget Function(BuildContext context, B bloc, S state, T selected) builder;

  /// Optional initial value to display before any state of type [T] is emitted.
  final T? initial;

  /// Optional widget to display while waiting for a state of type [T].
  final Widget? placeholder;

  const MorphSelector({
    super.key,
    required this.builder,
    this.initial,
    this.placeholder,
  });

  @override
  State<MorphSelector<B, S, T>> createState() => _MorphSelectorState<B, S, T>();
}

class _MorphSelectorState<B extends StateStreamable<S>, S, T>
    extends State<MorphSelector<B, S, T>> {
  late B bloc;
  late T? lastSelected;
  late S? lastState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<B>();
    lastState = (bloc as dynamic).state as S;
    if (lastState is T) {
      lastSelected = lastState as T;
    } else {
      lastSelected = widget.initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        if (state is T) {
          setState(() {
            lastState = state;
            lastSelected = state as T;
          });
        }
      },
      child: Builder(
        builder: (context) {
          if (lastSelected != null && lastState != null) {
            return widget.builder(context, bloc, lastState as S, lastSelected as T);
          }
          return widget.placeholder ?? const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
