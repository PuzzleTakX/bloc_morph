import 'package:bloc_morph/src/morph_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that manages UI states with Bloc, providing smooth transitions and highly customizable states.
///
/// The widget listens to a Bloc's state stream and renders UI based on the current [StatusState].
/// It supports pagination, custom error handling, and animations for state transitions.
///
/// Example:
/// ```dart
/// BlocMorph<MyBloc, MyState, MyData>(
///   builder: (data) => Text(data?.toString() ?? 'No Data'),
///   errorBuilder: (bloc, error) => Text('Error: $error'),
///   pagination: false,
///   errorMessage: 'Custom error message',
///   loadingWidget: CircularProgressIndicator(color: Colors.blue),
///   tryAgainButton: (onTry) => ElevatedButton(
///     onPressed: onTry,
///     child: Text('Retry'),
///   ),
/// )
/// ```
class BlocMorph<B extends StateStreamable<S>, S extends MorphState, R>
    extends StatefulWidget {
  /// The builder function to render the UI when the state is [StatusState.next].
  final Widget Function(R? data)? builder;
  final Widget Function(B bloc, R? data, StatusState statusState, int page)?
      paginationBuilder;

  /// The builder function to render the UI when the state is [StatusState.error].
  /// Provides the current bloc and error message for custom error handling.
  final Widget Function(B bloc, String error)? errorBuilder;

  /// Callback invoked when the state transitions to [StatusState.next].
  final Function(R data)? onNext;

  /// Callback invoked on any state change, providing the current [StatusState] and data.
  final Function(StatusState typeState, R data)? onState;

  /// Whether to disable animations for state transitions. Defaults to `false`.
  final bool disableAnimation;

  /// Custom widget to display when the state is [StatusState.loading].
  final Widget? loading;

  /// Custom widget to display when the state is [StatusState.empty].
  final Widget? empty;

  /// Callback to handle retry actions for error or network error states.
  final Function(B bloc)? onTry;

  /// Custom widget to display when the state is [StatusState.init].
  final Widget? initial;

  /// Custom widget to display when the state is [StatusState.networkError].
  final Widget Function(B bloc)? networkError;

  final Widget? child;

  /// Key to match states with the widget's request. Defaults to "public_key".
  final String? requestKey;

  // Customization parameters
  /// Duration of the animation when switching states.
  final Duration animationDuration;

  /// Duration of the reverse animation when switching states.
  final Duration reverseAnimationDuration;

  /// Curve for the animation when switching in a new state.
  final Curve switchInCurve;

  /// Curve for the animation when switching out the old state.
  final Curve switchOutCurve;

  /// Custom transition builder for the [AnimatedSwitcher].
  final Widget Function(Widget child, Animation<double> animation)?
      transitionBuilder;

  /// A function that allows defining a custom animation.
  /// This function takes the current child widget and animation controller, and should return the animated widget.
  final Widget Function(Widget child, Animation<double> animation)?
      customAnimationBuilder;

  /// Custom error message for [StatusState.error].
  final String? errorMessage;

  /// Custom message for [StatusState.empty].
  final String? emptyMessage;

  /// Custom sub-message for [StatusState.empty].
  final String? emptySubMessage;

  /// Custom message for [StatusState.init].
  final String? initMessage;

  /// Custom message for [StatusState.networkError].
  final String? networkErrorMessage;

  /// Icon for the error state.
  final IconData? errorIcon;

  /// Icon for the empty state.
  final IconData? emptyIcon;

  /// Icon for the network error state.
  final IconData? networkErrorIcon;

  /// Color for the error state icon and text.
  final Color? errorColor;

  /// Color for the empty state icon and text.
  final Color? emptyColor;

  /// Color for the network error state icon and text.
  final Color? networkErrorColor;

  /// Text style for the error message.
  final TextStyle? errorTextStyle;

  /// Text style for the empty message.
  final TextStyle? emptyTextStyle;

  /// Text style for the empty sub-message.
  final TextStyle? emptySubTextStyle;

  /// Text style for the init message.
  final TextStyle? initTextStyle;

  /// Custom try-again button builder for error and network error states.
  final Widget Function(void Function() onTry)? tryAgainButton;

  /// Platform style for default widgets (Material or Cupertino).
  final PlatformStyle platformStyle;

  /// Padding for the error widget.
  final EdgeInsets? errorPadding;

  /// Size of the error icon.
  final double? errorIconSize;

  /// A map to override the default widget builders for specific states.
  /// The key is the [StatusState] and the value is a function that returns the widget to display.
  final Map<StatusState, Widget Function(R? data, B bloc)>? stateBuilders;

  /// A map to override the default widget builders for specific states when no data is available.
  /// The key is the [StatusState] and the value is a function that returns the widget to display.
  /// This is particularly useful for states like error, empty, loading, etc., where 'data' might be null.
  final Map<StatusState, Widget Function(B bloc)>? noDataStateBuilders;

  /// Whether to enable scale animation for state transitions. Defaults to `true`.
  final bool? enableScale;

  /// The BLoC instance that this widget will interact with.
  /// This is typically provided by a `BlocProvider` higher up in the widget tree.
  final B? bloc;

  /// The current state of the BLoC.
  final S? state;

  /// The data associated with the current state.
  final R? data;

  final bool? streaming;

  /// Whether to enable fade animation for state transitions. Defaults to `true`.
  ///
  /// If `false`, no fade animation will be applied during state transitions.
  final bool? enableFade;

  const BlocMorph({
    super.key,
    this.builder,
    this.errorBuilder,
    this.onNext,
    this.bloc,
    this.streaming = true,
    this.state,
    this.data,
    this.onState,
    this.disableAnimation = false,
    this.loading,
    this.empty,
    this.onTry,
    this.enableFade = true,
    this.enableScale = true,
    this.initial,
    this.networkError,
    this.child,
    this.requestKey,
    this.animationDuration = const Duration(milliseconds: 400),
    this.reverseAnimationDuration = const Duration(milliseconds: 200),
    this.switchInCurve = Curves.easeInOutCubic,
    this.switchOutCurve = Curves.easeOut,
    this.transitionBuilder,
    this.customAnimationBuilder,
    this.errorMessage,
    this.emptyMessage,
    this.emptySubMessage,
    this.initMessage,
    this.networkErrorMessage,
    this.errorIcon,
    this.emptyIcon,
    this.networkErrorIcon,
    this.errorColor,
    this.emptyColor,
    this.networkErrorColor,
    this.errorTextStyle,
    this.emptyTextStyle,
    this.emptySubTextStyle,
    this.initTextStyle,
    this.tryAgainButton,
    this.platformStyle = PlatformStyle.material,
    this.errorPadding,
    this.errorIconSize,
    this.stateBuilders,
    this.noDataStateBuilders,
    this.paginationBuilder,
  });

  @override
  State<BlocMorph<B, S, R>> createState() => _BlocMorphState<B, S, R>();
}

enum PlatformStyle { material, cupertino }

class _BlocMorphState<B extends StateStreamable<S>, S extends MorphState, R>
    extends State<BlocMorph<B, S, R>> {
  R? data;
  int page = 1;
  StatusState statusState = StatusState.loading;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        if (widget.streaming == false) return;
        if (state is! R) return;
        final stateKey = (state as dynamic).requestKey as String?;
        if (widget.paginationBuilder != null) {
          page = (state as dynamic).page as int;
        }
        if (widget.requestKey != null) {
          if (stateKey == widget.requestKey) {
            if (data != state && mounted) {
              setState(() {
                data = state as R?;
                statusState = state.statusState;
                widget.onNext?.call(state as R);
              });
              widget.onState?.call(statusState, data as R);
            }
          }
        } else {
          if (data != state && mounted) {
            setState(() {
              data = state as R?;
              statusState = state.statusState;
              widget.onNext?.call(state as R);
            });
            widget.onState?.call(statusState, data as R);
          }
        }
      },
      builder: (context, state) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bloc = context.read<B>();
    Widget content;
    if (widget.stateBuilders?.containsKey(statusState) ?? false) {
      content = widget.stateBuilders![statusState]!(data, bloc);
    } else if (widget.noDataStateBuilders?.containsKey(statusState) ?? false) {
      content = widget.noDataStateBuilders![statusState]!(bloc);
    } else if (widget.paginationBuilder != null) {
      content = _buildStateWidgetWithPagination(bloc);
    } else if (widget.child != null) {
      content = widget.child!;
    } else {
      content = _buildStateWidget(bloc);
    }

    return widget.disableAnimation
        ? content
        : AnimatedSwitcher(
            duration: widget.animationDuration,
            reverseDuration: widget.reverseAnimationDuration,
            switchInCurve: widget.switchInCurve,
            switchOutCurve: widget.switchOutCurve,
            transitionBuilder: _buildTransition,
            child: KeyedSubtree(
              key: ValueKey(statusState),
              child: content,
            ),
          );
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    if (widget.customAnimationBuilder != null) {
      return widget.customAnimationBuilder!(child, animation);
    }
    if (widget.transitionBuilder != null) {
      return widget.transitionBuilder!(child, animation);
    }

    var transitionChild = child;
    if (widget.enableFade ?? true) {
      transitionChild = FadeTransition(
        opacity: Tween<double>(begin: 0.4, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: widget.switchInCurve),
        ),
        child: transitionChild,
      );
    }
    if (widget.enableScale ?? true) {
      transitionChild = ScaleTransition(
        scale: Tween<double>(begin: 0.98, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: widget.switchInCurve),
        ),
        child: transitionChild,
      );
    }
    return transitionChild;
  }

  Widget _buildStateWidget(B bloc) {
    switch (statusState) {
      case StatusState.init:
        return widget.initial ??
            _buildDefaultWidget(
              label: 'Initial state',
              message: widget.initMessage ?? 'Starting to load...',
              textStyle: widget.initTextStyle,
              icon: Icons.hourglass_empty,
              color: Theme.of(context).colorScheme.primary,
            );
      case StatusState.loading:
        return widget.loading ?? _buildLoadingWidget();
      case StatusState.next:
      case StatusState.success:
        return widget.builder != null
            ? widget.builder!(data)
            : _buildDefaultWidget(
                label: 'Success state',
                message: 'Operation successful',
                icon: Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.secondary,
              );
      case StatusState.empty:
        return widget.empty ?? _buildEmptyWidget();
      case StatusState.error:
        return widget.errorBuilder != null
            ? widget.errorBuilder!(bloc, (data as MorphState?)?.error ?? '')
            : _buildErrorWidget(
                bloc,
                widget.errorMessage ?? 'An error occurred while fetching data.',
                widget.errorIcon,
                widget.errorColor,
                widget.errorTextStyle);
      case StatusState.networkError:
        return widget.networkError != null
            ? widget.networkError!(bloc)
            : _buildErrorWidget(
                bloc,
                widget.networkErrorMessage ?? 'No internet connection.',
                widget.networkErrorIcon ?? CupertinoIcons.wifi_exclamationmark,
                widget.networkErrorColor,
                widget.errorTextStyle);
      case StatusState.refreshing:
        return widget.builder != null
            ? Stack(
                children: [
                  widget.builder!(data),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withAlpha(20),
                      child: Center(
                          child: widget.loading ?? _buildLoadingWidget()),
                    ),
                  ),
                ],
              )
            : widget.loading ?? _buildLoadingWidget();
      case StatusState.loadingMore:
      case StatusState.noMoreData:
        return widget.builder != null
            ? widget.builder!(data)
            : _buildDefaultWidget(
                label: 'No more data',
                message: 'No more data to load.',
                icon: Icons.inbox_outlined,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              );
      case StatusState.unknown:
        return _buildDefaultWidget(
          label: 'Unknown state',
          message: 'An unknown state occurred.',
          icon: Icons.help_outline,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }

  Widget _buildStateWidgetWithPagination(B bloc) {
    if (page != 1)
      return widget.paginationBuilder!(bloc, data, statusState, page);
    switch (statusState) {
      case StatusState.init:
        return widget.initial ??
            _buildDefaultWidget(
              label: 'Initial state',
              message: widget.initMessage ?? 'Starting to load...',
              textStyle: widget.initTextStyle,
              icon: Icons.hourglass_empty,
              color: Theme.of(context).colorScheme.primary,
            );
      case StatusState.loading:
        return widget.loading ?? _buildLoadingWidget();
      case StatusState.next:
      case StatusState.success:
        return widget.paginationBuilder != null
            ? widget.paginationBuilder!(bloc, data, statusState, page)
            : _buildDefaultWidget(
                label: 'Success state',
                message: 'Operation successful',
                icon: Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.secondary,
              );
      case StatusState.empty:
        return widget.empty ?? _buildEmptyWidget();
      case StatusState.error:
        return widget.errorBuilder != null
            ? widget.errorBuilder!(bloc, (data as MorphState?)?.error ?? '')
            : _buildErrorWidget(
                bloc,
                widget.errorMessage ?? 'An error occurred while fetching data.',
                widget.errorIcon,
                widget.errorColor,
                widget.errorTextStyle);
      case StatusState.networkError:
        return widget.networkError != null
            ? widget.networkError!(bloc)
            : _buildErrorWidget(
                bloc,
                widget.networkErrorMessage ?? 'No internet connection.',
                widget.networkErrorIcon ?? CupertinoIcons.wifi_exclamationmark,
                widget.networkErrorColor,
                widget.errorTextStyle);
      case StatusState.refreshing:
        return widget.builder != null
            ? Stack(
                children: [
                  widget.builder!(data),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withAlpha(20),
                      child: Center(
                          child: widget.loading ?? _buildLoadingWidget()),
                    ),
                  ),
                ],
              )
            : widget.loading ?? _buildLoadingWidget();
      case StatusState.loadingMore:
      case StatusState.noMoreData:
        return widget.builder != null
            ? widget.builder!(data)
            : _buildDefaultWidget(
                label: 'No more data',
                message: 'No more data to load.',
                icon: Icons.inbox_outlined,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              );
      case StatusState.unknown:
        return _buildDefaultWidget(
          label: 'Unknown state',
          message: 'An unknown state occurred.',
          icon: Icons.help_outline,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }

  Widget _buildDefaultWidget({
    required String label,
    required String message,
    IconData? icon,
    Color? color,
    TextStyle? textStyle,
  }) {
    final theme = Theme.of(context);
    return Semantics(
      label: label,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Semantics(
                label: '$label icon',
                child: Icon(
                  icon,
                  size: 60,
                  color: color ?? theme.colorScheme.onSurface,
                ),
              ),
            if (icon != null) const SizedBox(height: 13),
            Text(
              message,
              textDirection: TextDirection.ltr,
              style: textStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: color ?? theme.colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
              textScaler: MediaQuery.textScalerOf(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(B bloc, String message, IconData? icon, Color? color,
      TextStyle? textStyle) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Error state',
      child: Padding(
        padding: widget.errorPadding ?? const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: 'Error icon',
                child: Icon(
                  icon ??
                      (widget.platformStyle == PlatformStyle.material
                          ? Icons.error_outline
                          : CupertinoIcons.exclamationmark_triangle),
                  size: widget.errorIconSize ?? 60,
                  color: color ?? theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                message,
                textDirection: TextDirection.ltr,
                style: textStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: color ?? theme.colorScheme.error,
                    ),
                textAlign: TextAlign.center,
                textScaler: MediaQuery.textScalerOf(context),
              ),
              if (widget.onTry != null) ...[
                const SizedBox(height: 16),
                widget.tryAgainButton != null
                    ? widget.tryAgainButton!(() => widget.onTry!(bloc))
                    : _buildTryAgainButton(bloc, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Empty state',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Empty icon',
                child: Icon(
                  widget.emptyIcon ?? Icons.inbox,
                  size: 72,
                  color: widget.emptyColor ??
                      theme.colorScheme.onSurface.withAlpha(153),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.emptyMessage ?? 'No data available.',
                textDirection: TextDirection.ltr,
                style: widget.emptyTextStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                textAlign: TextAlign.center,
                textScaler: MediaQuery.textScalerOf(context),
              ),
              if (widget.emptySubMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.emptySubMessage!,
                  textDirection: TextDirection.ltr,
                  style: widget.emptySubTextStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withAlpha(127),
                      ),
                  textAlign: TextAlign.center,
                  textScaler: MediaQuery.textScalerOf(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: widget.loading ??
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
            strokeWidth: 3.0,
          ),
    );
  }

  Widget _buildTryAgainButton(B bloc, ThemeData theme) {
    return widget.platformStyle == PlatformStyle.material
        ? ElevatedButton(
            onPressed: () => widget.onTry!(bloc),
            child: const Text('Try Again'),
          )
        : CupertinoButton(
            color: theme.dividerColor.withAlpha(20),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            borderRadius: BorderRadius.circular(150),
            onPressed: () => widget.onTry!(bloc),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.refresh,
                    size: 18, color: theme.dividerColor),
                const SizedBox(width: 6),
                Text(
                  'Try Again',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: theme.dividerColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
  }
}
