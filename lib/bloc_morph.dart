import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum for different UI states.
enum TypeState { init, loading, empty, error, networkError, next }

/// A widget that manages UI states with Bloc, providing smooth transitions and highly customizable states.
///
/// Example:
/// ```dart
/// BlocMorph<MyBloc, MyState, MyData>(
///   builder: (data) => Text(data?.toString() ?? 'No Data'),
///   errorBuilder: (bloc, error) => Text('Error: $error'),
///   pagination: false,
///   errorMessage: 'Custom error message',
///   loadingWidget: CircularProgressIndicator(color: Colors.blue),
///   tryAgainButton: (bloc) => ElevatedButton(
///     onPressed: (){bloc.yourFuc(};
///     child: Text('Retry'),
///   ),
/// )
/// ```
class BlocMorph<B extends StateStreamable<S>, S, R> extends StatefulWidget {
  final Widget Function(R? data)? builder;
  final Widget Function(B bloc, String data)? errorBuilder;
  final Function(R data)? onNext;
  final Function(TypeState typeState, R? data)? onState;
  final bool pagination;
  final bool? disableAnimation;
  final Widget? loading;
  final Widget? empty;
  final Function(B bloc)? onTry;
  final Widget? initial;
  final Widget Function(B bloc)? netWorkError;
  final Widget? child;
  final String requestKey;

  // Customization parameters
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final Widget Function(Widget child, Animation<double> animation)? transitionBuilder;
  final String? errorMessage;
  final String? emptyMessage;
  final String? emptySubMessage;
  final String? initMessage;
  final String? networkErrorMessage;
  final IconData? errorIcon;
  final IconData? emptyIcon;
  final IconData? networkErrorIcon;
  final Color? errorColor;
  final Color? emptyColor;
  final Color? networkErrorColor;
  final TextStyle? errorTextStyle;
  final TextStyle? emptyTextStyle;
  final TextStyle? emptySubTextStyle;
  final TextStyle? initTextStyle;
  final Widget Function(void Function() onTry)? tryAgainButton;

  const BlocMorph({
    super.key,
    this.builder,
    this.empty,
    this.onState,
    this.onTry,
    this.requestKey = "public_key",
    this.pagination = false,
    this.onNext,
    this.disableAnimation = false,
    this.errorBuilder,
    this.loading,
    this.initial,
    this.child,
    this.netWorkError,
    // Customization parameters
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
  });

  @override
  State<BlocMorph<B, S, R>> createState() => _BlocMorphState<B, S, R>();
}

class _BlocMorphState<B extends StateStreamable<S>, S, R> extends State<BlocMorph<B, S, R>> {
  R? data;
  TypeState typeState = TypeState.loading;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        if (state is R) {
          String? stateKey;
          try {
            stateKey = (state as dynamic).requestKey;
          } catch (e) {
            stateKey = null;
          }
          if (stateKey != null ) {
          if (stateKey == widget.requestKey) {
            if (data != state) {
              if (mounted) {
                setState(() {
                  data = state;
                  typeState = (state as dynamic).typeState;
                  if (widget.onNext != null) widget.onNext!(state);
                });
                if (widget.onState != null) widget.onState!(typeState, data);
              }
            }
          }
        }else{
            if (data != state) {
              if (mounted) {
                setState(() {
                  data = state;
                  typeState = (state as dynamic).typeState;
                  if (widget.onNext != null) widget.onNext!(state);
                });
                if (widget.onState != null) widget.onState!(typeState, data);
              }
            }
          }
        }
      },
      builder: (context, state) => (widget.disableAnimation == true) ? _buildContent() : _content(),
    );
  }

  Widget _content() {
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      reverseDuration: widget.reverseAnimationDuration,
      transitionBuilder: widget.transitionBuilder ??
              (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: widget.switchInCurve,
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.7, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: widget.switchInCurve,
                  ),
                ),
                child: child,
              ),
            );
          },
      switchInCurve: widget.switchInCurve,
      switchOutCurve: widget.switchOutCurve,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (!widget.pagination) {
      if (widget.child != null) {
        return KeyedSubtree(
          key: const ValueKey('child'),
          child: widget.child!,
        );
      } else {
        switch (typeState) {
          case TypeState.error:
            return KeyedSubtree(
              key: const ValueKey(TypeState.error),
              child: widget.errorBuilder != null
                  ? widget.errorBuilder!(context.read<B>(), "")
                  : _buildErrorWidgetIOS(),
            );

          case TypeState.empty:
            return KeyedSubtree(
              key: const ValueKey(TypeState.empty),
              child: widget.empty ?? _buildEmptyWidget(),
            );

          case TypeState.init:
            return KeyedSubtree(
              key: const ValueKey(TypeState.init),
              child: widget.initial ?? _buildInitWidget(),
            );

          case TypeState.loading:
            return KeyedSubtree(
              key: const ValueKey(TypeState.loading),
              child: widget.loading ?? _buildLoadingWidget(),
            );

          case TypeState.networkError:
            return KeyedSubtree(
              key: const ValueKey(TypeState.networkError),
              child: widget.netWorkError != null
                  ? widget.netWorkError!(context.read<B>())
                  : _buildNetworkErrorWidget(),
            );

          case TypeState.next:
            return KeyedSubtree(
              key: const ValueKey(TypeState.next),
              child: widget.builder!(data),
            );
        }
      }
    } else {
      if (typeState == TypeState.next) {
        return KeyedSubtree(
          key: const ValueKey('pagination_next'),
          child: widget.builder!(data),
        );
      } else {
        return KeyedSubtree(
          key: const ValueKey('pagination_null'),
          child: widget.builder!(null),
        );
      }
    }
  }

  Widget _buildErrorWidgetIOS() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.errorIcon ?? CupertinoIcons.exclamationmark_triangle,
              size: 60,
              color: widget.errorColor ?? theme.colorScheme.error,
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
            ),
            if (widget.onTry != null) ...[
              const SizedBox(height: 16),
              widget.tryAgainButton != null
                  ? widget.tryAgainButton!(() => widget.onTry!(context.read<B>()))
                  : CupertinoButton(
                color: theme.dividerColor.withAlpha(20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                borderRadius: BorderRadius.circular(150),
                onPressed: () => widget.onTry!(context.read<B>()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.refresh, size: 18, color: theme.dividerColor),
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
    );
  }

  Widget _buildEmptyWidget() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.emptyIcon ?? Icons.inbox,
              size: 72,
              color: widget.emptyColor ?? theme.colorScheme.onSurface.withAlpha(153),
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
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInitWidget() {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        widget.initMessage ?? "Starting to load...",
        textDirection: TextDirection.ltr,
        style: widget.initTextStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: widget.loading ??
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              strokeWidth: 3.0,
            ),
      ),
    );
  }

  Widget _buildNetworkErrorWidget() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.networkErrorIcon ?? CupertinoIcons.wifi_exclamationmark,
              size: 60,
              color: widget.networkErrorColor ?? theme.colorScheme.error,
            ),
            const SizedBox(height: 13),
            Text(
              widget.networkErrorMessage ?? "No internet connection.",
              textDirection: TextDirection.ltr,
              style: widget.errorTextStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: widget.networkErrorColor ?? theme.colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            if (widget.onTry != null) ...[
              const SizedBox(height: 16),
              widget.tryAgainButton != null
                  ? widget.tryAgainButton!(() => widget.onTry!(context.read<B>()))
                  : CupertinoButton(
                color: theme.dividerColor.withAlpha(20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                borderRadius: BorderRadius.circular(150),
                onPressed: () => widget.onTry!(context.read<B>()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.refresh, size: 18, color: theme.dividerColor),
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
    );
  }
}