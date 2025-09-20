import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/item_image.dart';
import 'package:example/cubit/bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sample page demonstrating usage of a Cubit with BlocMorph
class SampleCubitPage extends StatefulWidget {
  const SampleCubitPage({super.key});

  @override
  State<SampleCubitPage> createState() => _SampleCubitPageState();
}

class _SampleCubitPageState extends State<SampleCubitPage> {

  @override
  void initState() {
    super.initState();
    // Fetch data from BlocCubit when the page initializes
    context.read<BlocCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sample Cubit'),
          actions: [
            // Refresh button to fetch data again
            IconButton(
              onPressed: () {
                context.read<BlocCubit>().fetchData();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocMorph<BlocCubit, BlocState, BlocDataState>(
          disableAnimation: false, // Enable or disable animation
          builder: (data) {
            // Build main content when data is loaded
            return _content(data!.data!);
          },
        ),
      ),
    );
  }

  /// Builds a scrollable list of ImageItem cards
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
              // Display image with rounded top corners
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
