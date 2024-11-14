sealed class AsyncState<T> {
  const AsyncState();
  const factory AsyncState.loading() = AsyncLoading<T>;
  const factory AsyncState.error(Object error) = AsyncError<T>;
  const factory AsyncState.data(T data) = AsyncData<T>;

  bool get isLoading => this is AsyncLoading;
  bool get isError => this is AsyncError;
  bool get isData => this is AsyncData;

  T? get data => isData ? (this as AsyncData<T>).data : null;
}

final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading() : super();
}

final class AsyncError<T> extends AsyncState<T> {
  const AsyncError(this.error) : super();

  final Object error;
}

final class AsyncData<T> extends AsyncState<T> {
  const AsyncData(this.data) : super();

  @override
  final T data;
}
