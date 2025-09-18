

import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/bloc_cubit.dart';
import 'package:example/bloc/item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SampleWithRequestKeyPage extends StatefulWidget {
  const SampleWithRequestKeyPage({super.key});

  @override
  State<SampleWithRequestKeyPage> createState() => _SampleWithRequestKeyPageState();
}

class _SampleWithRequestKeyPageState extends State<SampleWithRequestKeyPage> {

  @override
  void initState() {
    super.initState();
    context.read<BlocCubit>().sampleWithRequestKey('key1');
    context.read<BlocCubit>().sampleWithRequestKey('key2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sample With RequestKey'),
        actions: [
          IconButton(onPressed: (){context.read<BlocCubit>().sampleWithRequestKey('key1');}, icon: Icon(Icons.one_k)),
          IconButton(onPressed: (){context.read<BlocCubit>().sampleWithRequestKey('key2');}, icon: Icon(Icons.two_k))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(4),
            color: Colors.amber.withAlpha(50),
            child: BlocMorph<BlocCubit,BlocState,BlocSampleWithRequestKeyState>(
              requestKey: 'key1',
              disableAnimation: false,
              builder: (data) {
                return _content(data!.data!);
              },
            ),
          )),
          Expanded(child: Container(
            padding: EdgeInsets.all(4),
            color: Colors.grey.withAlpha(50),
            child: BlocMorph<BlocCubit,BlocState,BlocSampleWithRequestKeyState>(
              requestKey: 'key2',
              disableAnimation: false,
              builder: (data) {
                return _content(data!.data!);
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _content(List<ImageItem> data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  item.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
