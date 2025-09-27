import 'package:bloc_morph/bloc_morph.dart';
import 'package:example/bloc/model_wallpaper.dart';
import 'package:example/bloc/my_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SampleApiPagination extends StatefulWidget {
  const SampleApiPagination({super.key});

  @override
  State<SampleApiPagination> createState() => _SampleApiPaginationState();
}

class _SampleApiPaginationState extends State<SampleApiPagination> {
  final ScrollController _scrollController = ScrollController();
  List<DataWallPaper> data = [];
  int _currentPage = 1;
  bool _isPaging = true;
  final int _maxPages = 4;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_currentPage <= _maxPages && _isPaging == true) {
          _isPaging = false;
          _currentPage = _currentPage + 1;
          context.read<MyBloc>().fetchWallpapersPagination(_currentPage);
        }
      }
    });
  }

  void _fetchInitialData() {
    context.read<MyBloc>().fetchWallpapersPagination(_currentPage);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _currentPage < _maxPages &&
        _isPaging) {
      _isPaging = false;
      _currentPage++;
      context.read<MyBloc>().fetchWallpapersPagination(_currentPage);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample Api Pagination Page"),
        actions: [
          IconButton(
            onPressed: () {
              _currentPage = 1;
              data.clear();
              _isPaging = true;
              _fetchInitialData();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocMorph<MyBloc, MyState, DataLoadStatePage>(
        disableAnimation: true,
        paginationBuilder: (bloc, newData, statusState, page) {
          if (statusState == StatusState.next && newData?.data != null) {
            _isPaging = true;
            data.addAll(newData!.data!);
          }
          return _buildContent(
            data,
            (_currentPage < _maxPages && _isPaging == false),
          );
        },
      ),
    );
  }

  Widget _buildContent(List<DataWallPaper> data, bool isLoadingNextPage) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: data.length + (isLoadingNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == data.length && isLoadingNextPage) {
          return const Center(child: CircularProgressIndicator());
        }

        final wallpaper = data[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Image.network(
            wallpaper.imageUrl ?? 'https://via.placeholder.com/150',
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.error_outline, color: Colors.red),
          ),
        );
      },
    );
  }
}
