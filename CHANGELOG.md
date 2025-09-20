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

# Changelog

All notable changes to the `BlocMorph` widget will be documented in this file.

## [0.2.2] - 2025-Sep-20

### Added
- **Type Safety with `MorphState` Interface**: Introduced a `MorphState` interface to enforce type-safe access to `requestKey`, `typeState`, and `error` properties, eliminating unsafe `dynamic` casting.
- **Accessibility Support**: Added `Semantics` widgets to default state widgets (`_buildErrorWidget`, `_buildEmptyWidget`, `_buildInitWidget`, `_buildNetworkErrorWidget`) to support screen readers and improve accessibility. Included `textScaler` for text scaling based on device accessibility settings.
- **Platform Style Support**: Added `PlatformStyle` enum (`material`, `cupertino`) to allow default widgets to adapt to Material or Cupertino design systems based on the `platformStyle` parameter.
- **Customizable Error Padding and Icon Size**: Added `errorPadding` and `errorIconSize` parameters to allow customization of padding and icon size in error and network error states.
- **Comprehensive Documentation**: Added detailed DartDoc comments for all constructor parameters of `BlocMorph`, explaining their purpose, default behavior, and usage.

### Changed
- **Refactored `BlocConsumer` Listener Logic**: Simplified the listener logic in `_BlocMorphState` to reduce code duplication and improve readability by consolidating the `if` and `else` branches for state handling.
- **Optimized `AnimatedSwitcher` Usage**: Moved `AnimatedSwitcher` logic into `_buildContent` to apply animations only when `disableAnimation` is `false`, reducing unnecessary widget tree complexity.
- **Improved Key Management**: Ensured all branches in `_buildContent` use unique `ValueKey`s for `KeyedSubtree` widgets to prevent animation glitches in `AnimatedSwitcher`.
- **Enhanced Error Handling**: Updated `errorBuilder` to receive the actual error message from the `MorphState.error` field instead of an empty string, improving flexibility for custom error displays.
- **Renamed `_buildErrorWidgetIOS`**: Renamed to `_buildErrorWidget` for clarity and consistency, as it now supports both Material and Cupertino styles.
- **Fixed Documentation Example**: Corrected a syntax error in the example code in the `BlocMorph` documentation, fixing the `onPressed` callback (`yourFuc` to `yourFunction`) and ensuring proper syntax.

### Fixed
- **Null-Safety for Callbacks**: Added null-safety checks for optional callbacks (`onNext`, `onState`, `onTry`) using the `?.` operator to prevent runtime null pointer exceptions.
- **Animation Key Issues**: Fixed potential animation glitches by ensuring all state widgets in `_buildContent` have unique keys, particularly for pagination and non-pagination cases.


### [0.1.4] - 2025-Sep-18
- Initial Commit


<p align="center">Built with ❤️ for the PuzzleTakX</p>