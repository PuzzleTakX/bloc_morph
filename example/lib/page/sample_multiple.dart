import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';

class SampleMultiple extends StatefulWidget {
  const SampleMultiple({super.key});

  @override
  State<SampleMultiple> createState() => _SampleMultipleState();
}

class _SampleMultipleState extends State<SampleMultiple> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MorphSelector<MyBloc, MyState, DataLoadState>(
        builder: (context, bloc, state, selected) => Container(),
      ),
    );
  }
}
