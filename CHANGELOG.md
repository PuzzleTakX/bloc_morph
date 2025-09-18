<div align="center">
  <img src="https://raw.githubusercontent.com/PuzzleTakX/bloc_morph/refs/heads/master/example/assets/images/logo_bloc_morph.png" alt="BlocMorph Logo" width="300"/>
</div>

# BlocMorph

A powerful and flexible Flutter package for managing UI states with the Bloc pattern, featuring smooth animations and highly customizable widgets. `BlocMorph` simplifies handling various UI states like loading, error, empty, and network issues, while providing seamless transitions and a polished user experience.

![Pub Version](https://img.shields.io/pub/v/bloc_morph?color=blue&style=flat-square)
![License](https://img.shields.io/github/license/PuzzleTakX/bloc_morph?color=green&style=flat-square)
![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue?style=flat-square)
![Dart Version](https://img.shields.io/badge/Dart-%3E%3D2.17.0%20%3C4.0.0-blue?style=flat-square)


## 📜 Changelog

### [0.1.4] - 2025-Sep-18
- Initial Commit

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

- **Your dependency on "flutter_bloc" should have a version constraint.

## Installation

Add `bloc_morph` to your `pubspec.yaml`:

```yaml
dependencies:
  bloc_morph: ^0.1.4
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


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, feel free to open an issue on the [GitHub repository](https://github.com/PuzzleTakX/bloc_morph) or contact the maintainer at [your-email@example.com].

---

<p align="center">Built with ❤️ for the PuzzleTakX</p>