<div align="center">
  <img src="https://raw.githubusercontent.com/PuzzleTakX/bloc_morph/refs/heads/master/example/assets/images/logo_bloc_morph.png" alt="BlocMorph Logo" width="300"/>
</div>

# BlocMorph

A powerful and flexible Flutter package for managing UI states with the Bloc pattern, featuring smooth animations and highly customizable widgets. `BlocMorph` simplifies handling various UI states like loading, error, empty, and network issues, while providing seamless transitions and a polished user experience.

[![Pub Version](https://img.shields.io/pub/v/bloc_morph?color=blue&style=flat-square)](https://pub.dev/packages/bloc_morph)
[![License](https://img.shields.io/github/license/PuzzleTakX/bloc_morph?color=green&style=flat-square)](https://pub.dev/packages/bloc_morph)
[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue?style=flat-square)](https://pub.dev/packages/bloc_morph)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D2.17.0%20%3C4.0.0-blue?style=flat-square)](https://pub.dev/packages/bloc_morph)

# Demo Comparison

Here is a visual comparison of different screens (square format):

| Bad                                                                                                                          | Good                                                                                                                         |
|------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| <img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/1.png?raw=true" alt="Screen 1" width="300" height="300"> | <img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/2.png?raw=true" alt="Screen 2" width="300" height="300"> |
| <img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/3.png?raw=true" alt="Screen 3" width="300" height="300"> | <img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/4.png?raw=true" alt="Screen 4" width="300" height="300"> |

*Left column vs Right column comparison.*


### Example Ease
 ```dart
BlocMorph<BlocCubit,BlocState,BlocSampleState>(
initial: Container(color: Colors.grey,),
empty: Container(color: Colors.orange,),
errorBuilder: (bloc, data) => Container(color: Colors.red,),
netWorkError: (bloc) => Container(color: Colors.blue,),
loading: CircularProgressIndicator(),
builder: (data) {
return _content(data!.data!);
},
)
 ```

<div style="display: flex; justify-content: space-between;">
<img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/tree.jpg?raw=true" alt="image_demo" width="260" height="600">
<img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/two.jpg?raw=true" alt="image_demo" width="260" height="600">
<img src="https://github.com/PuzzleTakX/bloc_morph/blob/master/demo/one.jpg?raw=true" alt="image_demo" width="260" height="600">
</div>

## Features

- **Smooth Animations**: Built-in transitions with scale (0.9 to 1) and fade effects for seamless state changes.
- **Highly Customizable**: Customize icons, messages, colors, text styles, and retry buttons for all UI states.
- **Bloc Integration**: Works seamlessly with `flutter_bloc` to manage state changes efficiently.
- **Pagination Support**: Handles paginated data with ease, perfect for lists and infinite scrolling.
- **Lightweight and Performant**: Optimized for performance with minimal dependencies.
- **Multi-language Support**: Configurable messages and text directions for global compatibility.
- **Extensible**: Allows custom transition animations and fully replaceable default widgets.

## Installation

Add `bloc_morph` to your `pubspec.yaml`:

```yaml
dependencies:
  bloc_morph: ^0.2.1
```

Then, run:

```bash
flutter pub get
```

Alternatively, if you want to use the latest version from the GitHub repository:

```yaml
dependencies:
  bloc_morph:
    git:
      url: https://github.com/PuzzleTakX/bloc_morph.git
      ref: master
```

## Usage

`BlocMorph` is designed to work with any `Bloc` or `Cubit` from the `flutter_bloc` package. It handles various UI states (`init`, `loading`, `empty`, `error`, `networkError`, `next`) and provides smooth transitions between them.


### Example

Below is an example of using `BlocMorph` to display a list of items with customizable error, empty, and loading states:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_morph/bloc_morph.dart';
import 'bloc_cubit.dart';
import 'item_image.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  void initState() {
    super.initState();
    context.read<BlocCubit>().sample1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlocMorph Sample'),
        actions: [
          IconButton(
            onPressed: () => context.read<BlocCubit>().sample1(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocMorph<BlocCubit, BlocState, BlocSampleState>(
        builder: (data) => _content(data!.data!),
        errorMessage: 'Failed to load data!',
        errorIcon: Icons.error_outline,
        errorColor: Colors.redAccent,
        emptyMessage: 'No items found!',
        emptySubMessage: 'Try loading again.',
        emptyIcon: Icons.inbox,
        initMessage: 'Initializing...',
        networkErrorMessage: 'Check your internet connection!',
        networkErrorIcon: Icons.wifi_off,
        tryAgainButton: (onTry) => ElevatedButton(
          onPressed: onTry,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTry: (bloc) => bloc.sample1(),
        animationDuration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
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
```

### Available States

`BlocMorph` supports the following UI states, each with customizable widgets:

- **init**: Initial state before loading starts.
- **loading**: Displays while data is being fetched.
- **empty**: Shown when no data is available.
- **error**: Displayed for general errors.
- **networkError**: Shown for network-related issues.
- **next**: Renders the main content when data is available.

### Customization Options

You can customize the appearance and behavior of each state:

- **Messages**: Set custom messages for `error`, `empty`, `init`, and `networkError` states.
- **Icons**: Provide custom icons for each state (e.g., `errorIcon`, `emptyIcon`).
- **Colors**: Define colors for icons and text (e.g., `errorColor`, `networkErrorColor`).
- **Text Styles**: Customize text styles for messages (e.g., `errorTextStyle`, `emptyTextStyle`).
- **Retry Button**: Provide a custom retry button using `tryAgainButton`.
- **Animations**: Adjust animation duration, curves, or provide a custom `transitionBuilder`.

Example with customizations:

```dart
BlocMorph<MyBloc, MyState, MyData>(
  builder: (data) => Text(data?.toString() ?? 'No Data'),
  errorMessage: 'Custom error message',
  errorIcon: Icons.error_outline,
  errorColor: Colors.redAccent,
  tryAgainButton: (onTry) => ElevatedButton(
    onPressed: onTry,
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    child: const Text('Retry', style: TextStyle(color: Colors.white)),
  ),
  animationDuration: const Duration(milliseconds: 600),
  transitionBuilder: (child, animation) => SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  ),
)
```

## Project Structure

The `BlocMorph` package has the following structure:

```
bloc_morph/
├── lib/
│   └── bloc_morph.dart          # Main widget and logic
├── example/
│   ├── lib/
│   │   ├── main.dart            # Sample app
│   │   ├── bloc_cubit.dart      # Sample Bloc/Cubit
│   │   ├── bloc_state.dart      # Sample Bloc/State
│   │   └── item_image.dart      # Sample data model
│   └── pubspec.yaml             # Example dependencies
├── test/
│   └── bloc_morph_test.dart     # Unit tests
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Running the Example

To run the example project, navigate to the `example` directory and run:

```bash
cd example
flutter pub get
flutter run
```

The example demonstrates how to use `BlocMorph` with a simple `Cubit` to handle different UI states with smooth animations.

## Dependencies

- `flutter_bloc: ^8.1.3`
- `cupertino_icons: ^1.0.6`

## Supported Versions

- **Dart**: `>=2.17.0 <4.0.0`
- **Flutter**: `>=3.0.0`

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes and commit (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, feel free to open an issue on the [GitHub repository](https://github.com/PuzzleTakX/bloc_morph) or contact the maintainer at [your-email@example.com].

---

<p align="center">Built with ❤️ for the PuzzleTakX</p>