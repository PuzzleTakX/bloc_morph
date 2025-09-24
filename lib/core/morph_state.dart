
/// Interface for states to ensure type safety and required properties.
abstract class MorphState {
  String? get requestKey;
  String? get error;
  StatusState get statusState;
}

/// Enum defining possible UI states for the BlocMorph widget.
enum StatusState { init, loading, empty, error, networkError, next, success, refreshing, loadingMore, noMoreData, unknown }

/// Represents the initial state.
class InitialState implements MorphState {
  @override
  String? get requestKey => null;
  @override
  String? get error => null;
  @override
  StatusState get statusState => StatusState.init;
}
