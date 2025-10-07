import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// MorphSelectorMultiple
/// ---------------------------
/// StatefulWidget that rebuilds only when the builderState matches the current state
/// or when selected values (optional) change. Other state changes are ignored.
///
/// Example usage:
/// ```dart
/// MorphSelectorMultiple<MyBloc, MyState>(
///   builderState: (state) => state is StateData,
///   builder: (context, bloc, state) {
///     if (state is StateData) {
///       return ListView(
///         children: state.items.map((e) => Text(e)).toList(),
///       );
///     }
///     return const Center(child: CircularProgressIndicator());
///   },
/// )
/// ```
class MorphSelectorMultiple<B extends StateStreamable<S>, S>
    extends StatefulWidget {
  /// Function to decide whether this state should rebuild the UI
  final bool Function(S state) builderState;

  /// Builder function receiving the bloc and current state
  final Widget Function(BuildContext context, B bloc, S state) builder;

  const MorphSelectorMultiple({
    super.key,
    required this.builderState,
    required this.builder,
  });

  @override
  State<MorphSelectorMultiple<B, S>> createState() =>
      _MorphSelectorMultipleState<B, S>();
}

class _MorphSelectorMultipleState<B extends StateStreamable<S>, S>
    extends State<MorphSelectorMultiple<B, S>> {
  late B bloc;
  late S lastState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<B>();
    lastState = (bloc as dynamic).state as S;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        if (widget.builderState(state)) {
          setState(() {
            lastState = state;
          });
        }
      },
      child: widget.builder(context, bloc, lastState),
    );
  }
}
