


import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/model_wallpaper.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SampleApiPage extends StatefulWidget {
  const SampleApiPage({super.key});

  @override
  State<SampleApiPage> createState() => _SampleApiPageState();
}

class _SampleApiPageState extends State<SampleApiPage> {

  @override
  void initState() {
    super.initState();
    context.read<MyBloc>().fetchWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sample Api Page"),
        actions: [
          IconButton(onPressed: (){
            context.read<MyBloc>().fetchWallpapers();
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: BlocMorph<MyBloc, MyState,DataLoadState>(
        builder:(data) => _buildContent(data!.data ?? []),
      ),
    );
  }


  Widget _buildContent(List<DataWallPaper> data){
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
            wallpaper.imageUrl ?? 'https://via.placeholder.com/150', // Provide a placeholder if src is null
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        );
      },
    );
  }

}
