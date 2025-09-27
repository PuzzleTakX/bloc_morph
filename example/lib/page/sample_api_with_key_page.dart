import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/model_wallpaper.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SampleApiWithKeyPage extends StatefulWidget {
  const SampleApiWithKeyPage({super.key});

  @override
  State<SampleApiWithKeyPage> createState() => _SampleApiWithKeyPageState();
}

class _SampleApiWithKeyPageState extends State<SampleApiWithKeyPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyBloc>().fetchWallpapersWithKey("key_one");
    context.read<MyBloc>().fetchWallpapersWithKey("key_two");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Api Page"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<MyBloc>().fetchWallpapersWithKey("key_one");
            },
            icon: Text("One"),
          ),
          IconButton(
            onPressed: () {
              context.read<MyBloc>().fetchWallpapersWithKey("key_two");
            },
            icon: Text("Two"),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocMorph<MyBloc, MyState, DataLoadState>(
              requestKey: "key_one",
              builder: (data) => _buildContent(data!.data ?? []),
            ),
          ),
          Expanded(
            child: BlocMorph<MyBloc, MyState, DataLoadState>(
              requestKey: "key_two",
              builder: (data) => _buildContent(data!.data ?? []),
            ),
          ),
        ],
      ),
    );
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
