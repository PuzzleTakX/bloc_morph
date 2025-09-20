
/// Interface for states to ensure type safety and required properties.
abstract class MorphState {
  String? get requestKey;
  String? get error;
  TypeState get typeState;
}
/// Enum defining possible UI states for the BlocMorph widget.
enum TypeState { init, loading, empty, error, networkError, next }