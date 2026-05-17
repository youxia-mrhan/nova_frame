class ChannelResult<T> {
  const ChannelResult._({
    required this.ok,
    this.data,
    this.error,
    this.stack,
  });

  final bool ok;
  final T? data;
  final Object? error;
  final StackTrace? stack;

  factory ChannelResult.success(T data) => ChannelResult._(ok: true, data: data);

  factory ChannelResult.failure(Object error, [StackTrace? stack]) =>
      ChannelResult._(ok: false, error: error, stack: stack);
}

