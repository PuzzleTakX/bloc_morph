import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum for different UI states.
enum TypeState { init, loading, empty, error, networkError, next }

/// A widget that manages UI states with Bloc, providing smooth transitions and customizable states.
///
/// Example:
/// ```dart
/// BlocMorph<MyBloc, MyState, MyData>(
///   builder: (data) => Text(data?.toString() ?? 'No Data'),
///   errorBuilder: (bloc, error) => Text('Error: $error'),
///   pagination: false,
/// )
/// ```
class BlocMorph<B extends StateStreamable<S>, S, R> extends StatefulWidget {
  final Widget Function(R? data)? builder;
  final Widget Function(B bloc, String data)? errorBuilder;
  final Function(R data)? onNext;
  final Function(TypeState typeState, R? data)? onState;
  final bool? pagination;
  final Widget? loading;
  final Widget? empty;
  final Function(B bloc)? onTry;
  final Widget? initial;
  final Widget Function(B bloc)? netWorkError;
  final Widget? child;
  final String requestKey;

  const BlocMorph({
    super.key,
    this.builder,
    this.empty,
    this.onState,
    this.onTry,
    this.requestKey = "public_key",
    this.pagination = false,
    this.onNext,
    this.errorBuilder,
    this.loading,
    this.initial,
    this.child,
    this.netWorkError,
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
          if (stateKey != null && stateKey == widget.requestKey || stateKey == null) {
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
      builder: (context, state) => _content(),
    );
  }

  Widget _content() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          ),
        );
      },
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeOut,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.pagination == false) {
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

  Widget _buildErrorWidgetIOS({
    IconData icon = CupertinoIcons.exclamationmark_triangle,
    String message = "An error occurred while fetching data.",
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: color ?? theme.colorScheme.error),
            const SizedBox(height: 13),
            Text(
              message,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color ?? theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              color: theme.dividerColor.withAlpha(20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              borderRadius: BorderRadius.circular(150),
              onPressed: widget.onTry == null
                  ? null
                  : () => widget.onTry!(context.read<B>()),
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
        ),
      ),
    );
  }

  Widget _buildEmptyWidget({
    IconData icon = Icons.inbox,
    String message = "No data available.",
    String subMessage = "Try refreshing or check back later.",
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 72,
              color: theme.colorScheme.onSurface.withAlpha(153), // 0.6 * 255 ≈ 153
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withAlpha(153), // 0.6 * 255
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subMessage,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withAlpha(127), // 0.5 * 255
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInitWidget({
    String message = "Starting to load...",
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        message,
        textDirection: TextDirection.ltr,
        style: theme.textTheme.bodyMedium?.copyWith(
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
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          strokeWidth: 3.0,
          value: null,
        ),
      ),
    );
  }

  Widget _buildNetworkErrorWidget({
    IconData icon = CupertinoIcons.wifi_exclamationmark,
    String message = "No internet connection.",
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: color ?? theme.colorScheme.error),
            const SizedBox(height: 13),
            Text(
              message,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color ?? theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              color: theme.dividerColor.withAlpha(20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              borderRadius: BorderRadius.circular(150),
              onPressed: widget.onTry == null
                  ? null
                  : () => widget.onTry!(context.read<B>()),
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
        ),
      ),
    );
  }
}