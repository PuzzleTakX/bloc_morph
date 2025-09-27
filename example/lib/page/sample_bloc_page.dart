import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/item_image.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sample page to display data using BLoC and BlocMorph
class SampleBlocPage extends StatefulWidget {
  const SampleBlocPage({super.key});

  @override
  State<SampleBlocPage> createState() => _SampleBlocPageState();
}

class _SampleBlocPageState extends State<SampleBlocPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data from MyBloc when the page initializes
    context.read<MyBloc>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sample Bloc'),
          actions: [
            // Refresh button to fetch data again
            IconButton(
              onPressed: () {
                context.read<MyBloc>().fetchData();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocMorph<MyBloc, MyState, DataLoadState>(
          builder: (data) {
            return _content(data!.data!); // response
          },
        ),
      ),
    );
  }

  /// Builds a list widget displaying image items
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
              // Display image with rounded corners
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  item.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display item title
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Display item description
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
