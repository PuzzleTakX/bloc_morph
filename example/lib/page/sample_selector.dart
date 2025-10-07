import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';

class SampleSelector extends StatefulWidget {
  const SampleSelector({super.key});

  @override
  State<SampleSelector> createState() => _SampleSelectorState();
}

class _SampleSelectorState extends State<SampleSelector> {
  @override
  Widget build(BuildContext context) {
    return MorphSelectorMultiple<MyBloc, MyState>(
      builderState: (state) {
        if (state is DataLoadState) return true;
        if (state is DataLoadStatePage) return true;
        return false;
      },
      builder: (context, bloc, state) => Container(),
    );
  }
}
