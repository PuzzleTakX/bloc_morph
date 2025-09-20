import 'package:bloc_morph/core/morph_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that manages UI states with Bloc, providing smooth transitions and highly customizable states.
///
/// The widget listens to a Bloc's state stream and renders UI based on the current [TypeState].
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
  /// The builder function to render the UI when the state is [TypeState.next].
  final Widget Function(R? data)? builder;

  /// The builder function to render the UI when the state is [TypeState.error].
  /// Provides the current bloc and error message for custom error handling.
  final Widget Function(B bloc, String error)? errorBuilder;

  /// Callback invoked when the state transitions to [TypeState.next].
  final Function(R data)? onNext;

  /// Callback invoked on any state change, providing the current [TypeState] and data.
  final Function(TypeState typeState, R? data)? onState;

  /// Whether to enable pagination mode. If `true`, the widget renders differently based on [TypeState.next].
  final bool pagination;

  /// Whether to disable animations for state transitions. Defaults to `false`.
  final bool disableAnimation;

  /// Custom widget to display when the state is [TypeState.loading].
  final Widget? loading;

  /// Custom widget to display when the state is [TypeState.empty].
  final Widget? empty;

  /// Callback to handle retry actions for error or network error states.
  final Function(B bloc)? onTry;

  /// Custom widget to display when the state is [TypeState.init].
  final Widget? initial;

  /// Custom widget to display when the state is [TypeState.networkError].
  final Widget Function(B bloc)? networkError;

  /// A static child widget to display regardless of state (used when [pagination] is `false`).
  final Widget? child;

  /// Key to match states with the widget's request. Defaults to "public_key".
  final String requestKey;

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

  /// Custom error message for [TypeState.error].
  final String? errorMessage;

  /// Custom message for [TypeState.empty].
  final String? emptyMessage;

  /// Custom sub-message for [TypeState.empty].
  final String? emptySubMessage;

  /// Custom message for [TypeState.init].
  final String? initMessage;

  /// Custom message for [TypeState.networkError].
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

  const BlocMorph({
    super.key,
    this.builder,
    this.errorBuilder,
    this.onNext,
    this.onState,
    this.pagination = false,
    this.disableAnimation = false,
    this.loading,
    this.empty,
    this.onTry,
    this.initial,
    this.networkError,
    this.child,
    this.requestKey = "public_key",
    this.animationDuration = const Duration(milliseconds: 400),
    this.reverseAnimationDuration = const Duration(milliseconds: 200),
    this.switchInCurve = Curves.easeInOutCubic,
    this.switchOutCurve = Curves.easeOut,
    this.transitionBuilder,
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
  });

  @override
  State<BlocMorph<B, S, R>> createState() => _BlocMorphState<B, S, R>();
}

enum PlatformStyle { material, cupertino }

class _BlocMorphState<B extends StateStreamable<S>, S extends MorphState, R>
    extends State<BlocMorph<B, S, R>> {
  R? data;
  TypeState typeState = TypeState.loading;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        if (state is! R) return;
        String? stateKey;
        try {
          stateKey = state.requestKey;
        } catch (e) {
          stateKey = null;
        }
        if (stateKey != null) {
        if (stateKey == widget.requestKey) {
          if (data != state && mounted) {
            setState(() {
              data = state as R?;
              typeState = state.typeState;
              widget.onNext?.call(state as R);
            });
            widget.onState?.call(typeState, data);
          }
        }
        }else{
          if (data != state && mounted) {
            setState(() {
              data = state as R?;
              typeState = state.typeState;
              widget.onNext?.call(state as R);
            });
            widget.onState?.call(typeState, data);
          }
        }
      },
      builder: (context, state) => _buildContent(),
    );
  }

  Widget _buildContent() {
    Widget content;
    if (!widget.pagination) {
      if (widget.child != null) {
        content = KeyedSubtree(
          key: const ValueKey('child'),
          child: widget.child!,
        );
      } else {
        switch (typeState) {
          case TypeState.error:
            content = KeyedSubtree(
              key: const ValueKey(TypeState.error),
              child: widget.errorBuilder != null
                  ? widget.errorBuilder!(
                      context.read<B>(), (data as MorphState?)?.error ?? "")
                  : _buildErrorWidget(),
            );
            break;
          case TypeState.empty:
            content = KeyedSubtree(
              key: const ValueKey(TypeState.empty),
              child: widget.empty ?? _buildEmptyWidget(),
            );
            break;
          case TypeState.init:
            content = KeyedSubtree(
              key: const ValueKey(TypeState.init),
              child: widget.initial ?? _buildInitWidget(),
            );
            break;
          case TypeState.loading:
            content = KeyedSubtree(
              key: const ValueKey(TypeState.loading),
              child: widget.loading ?? _buildLoadingWidget(),
            );
            break;
          case TypeState.networkError:
            content = KeyedSubtree(
              key: const ValueKey(TypeState.networkError),
              child: widget.networkError != null
                  ? widget.networkError!(context.read<B>())
                  : _buildNetworkErrorWidget(),
            );
            break;
          case TypeState.next:
            content = KeyedSubtree(
              key: const ValueKey(TypeState.next),
              child: widget.builder!(data),
            );
            break;
        }
      }
    } else {
      content = KeyedSubtree(
        key: ValueKey(typeState == TypeState.next
            ? 'pagination_next'
            : 'pagination_null'),
        child: widget.builder!(typeState == TypeState.next ? data : null),
      );
    }

    return widget.disableAnimation
        ? content
        : AnimatedSwitcher(
            duration: widget.animationDuration,
            reverseDuration: widget.reverseAnimationDuration,
            transitionBuilder: widget.transitionBuilder ??
                (child, animation) => ScaleTransition(
                      scale: Tween<double>(begin: 0.98, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: widget.switchInCurve,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.4, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: widget.switchInCurve,
                          ),
                        ),
                        child: child,
                      ),
                    ),
            switchInCurve: widget.switchInCurve,
            switchOutCurve: widget.switchOutCurve,
            child: KeyedSubtree(
              key: ValueKey(typeState),
              child: content,
            ),
          );
  }

  Widget _buildErrorWidget() {
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
                  widget.platformStyle == PlatformStyle.material
                      ? Icons.error_outline
                      : CupertinoIcons.exclamationmark_triangle,
                  size: widget.errorIconSize ?? 60,
                  color: widget.errorColor ?? theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                widget.errorMessage ?? "An error occurred while fetching data.",
                textDirection: TextDirection.ltr,
                style: widget.errorTextStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: widget.errorColor ?? theme.colorScheme.error,
                    ),
                textAlign: TextAlign.center,
                textScaler: MediaQuery.textScalerOf(context),
              ),
              if (widget.onTry != null) ...[
                const SizedBox(height: 16),
                widget.tryAgainButton != null
                    ? widget
                        .tryAgainButton!(() => widget.onTry!(context.read<B>()))
                    : widget.platformStyle == PlatformStyle.material
                        ? ElevatedButton(
                            onPressed: () => widget.onTry!(context.read<B>()),
                            child: const Text("Try Again"),
                          )
                        : CupertinoButton(
                            color: theme.dividerColor.withAlpha(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            borderRadius: BorderRadius.circular(150),
                            onPressed: () => widget.onTry!(context.read<B>()),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.refresh,
                                    size: 18, color: theme.dividerColor),
                                const SizedBox(width: 6),
                                Text(
                                  "Try Again",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13,
                                    color: theme.dividerColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                widget.emptyMessage ?? "No data available.",
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

  Widget _buildInitWidget() {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Initial state',
      child: Center(
        child: Text(
          widget.initMessage ?? "Starting to load...",
          textDirection: TextDirection.ltr,
          style: widget.initTextStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.colorScheme.primary,
              ),
          textScaler: MediaQuery.textScalerOf(context),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: widget.loading ??
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            strokeWidth: 3.0,
          ),
    );
  }

  Widget _buildNetworkErrorWidget() {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Network error state',
      child: Padding(
        padding: widget.errorPadding ?? const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: 'Network error icon',
                child: Icon(
                  widget.networkErrorIcon ??
                      CupertinoIcons.wifi_exclamationmark,
                  size: widget.errorIconSize ?? 60,
                  color: widget.networkErrorColor ?? theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                widget.networkErrorMessage ?? "No internet connection.",
                textDirection: TextDirection.ltr,
                style: widget.errorTextStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          widget.networkErrorColor ?? theme.colorScheme.error,
                    ),
                textAlign: TextAlign.center,
                textScaler: MediaQuery.textScalerOf(context),
              ),
              if (widget.onTry != null) ...[
                const SizedBox(height: 16),
                widget.tryAgainButton != null
                    ? widget
                        .tryAgainButton!(() => widget.onTry!(context.read<B>()))
                    : widget.platformStyle == PlatformStyle.material
                        ? ElevatedButton(
                            onPressed: () => widget.onTry!(context.read<B>()),
                            child: const Text("Try Again"),
                          )
                        : CupertinoButton(
                            color: theme.dividerColor.withAlpha(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            borderRadius: BorderRadius.circular(150),
                            onPressed: () => widget.onTry!(context.read<B>()),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.refresh,
                                    size: 18, color: theme.dividerColor),
                                const SizedBox(width: 6),
                                Text(
                                  "Try Again",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13,
                                    color: theme.dividerColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
