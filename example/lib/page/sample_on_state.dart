import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/model_wallpaper.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SampleOnState extends StatefulWidget {
  const SampleOnState({super.key});

  @override
  State<SampleOnState> createState() => _SampleOnStateState();
}

class _SampleOnStateState extends State<SampleOnState> {
  List<String> state = [];

  @override
  void initState() {
    super.initState();
    context.read<MyBloc>().fetchWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Api Page"),
        actions: [
          IconButton(
            onPressed: () {
              // state.clear();
              context.read<MyBloc>().fetchWallpapers();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocMorph<MyBloc, MyState, DataLoadState>(
            onState: onState,
            builder: (data) => _buildContent(data!.data ?? []),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 150,
              height: 250,
              color: Colors.white70,
              padding: EdgeInsets.all(4),
              child: ListView(
                children:
                    state
                        .map(
                          (e) => Text(
                            "Status $e",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onState(typeState, DataLoadState data) {
    setState(() {
      state.add(typeState.toString().split('.').last);
    });
  }

  Widget _buildContent(List<DataWallPaper> data) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8.0, // Horizontal space between items
        mainAxisSpacing: 8.0, // Vertical space between items
        childAspectRatio: 0.75, // Aspect ratio of the items
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final wallpaper = data[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Image.network(
            wallpaper.imageUrl ??
                'https://via.placeholder.com/150', // Provide a placeholder if src is null
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => const Icon(Icons.error),
          ),
        );
      },
    );
  }
}
