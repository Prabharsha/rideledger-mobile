import 'dart:async';

/// Generic write-behind buffer that accumulates items in memory and flushes
/// them in batches via a caller-supplied callback.
///
/// Designed for Isar bulk writes (e.g. [RoutePointModel], [WarningEventModel])
/// but works with any type.
///
/// Error handling: if the flush callback throws, the failed items are retained
/// in the buffer so the next flush attempt will retry them along with any
/// newly added items.
class BatchWriter<T> {
  /// Number of items that triggers an automatic flush.
  final int batchSize;

  /// Callback that persists a batch of items.
  final Future<void> Function(List<T>) _writeCallback;

  /// Internal buffer of pending items.
  final List<T> _buffer = [];

  /// Guards against concurrent flushes.
  bool _flushing = false;

  /// Set to true after [dispose] is called.
  bool _disposed = false;

  /// Creates a [BatchWriter] that flushes every [batchSize] items using
  /// [writeCallback].
  ///
  /// [batchSize] must be at least 1.
  BatchWriter({
    required this.batchSize,
    required Future<void> Function(List<T>) writeCallback,
  })  : assert(batchSize >= 1, 'batchSize must be >= 1'),
        _writeCallback = writeCallback;

  /// Number of items waiting to be flushed.
  int get pendingCount => _buffer.length;

  /// Whether the writer has been disposed.
  bool get isDisposed => _disposed;

  /// Adds a single item to the buffer. Triggers an automatic flush when the
  /// buffer reaches [batchSize].
  Future<void> add(T item) async {
    _assertNotDisposed();
    _buffer.add(item);

    if (_buffer.length >= batchSize) {
      await flush();
    }
  }

  /// Adds multiple items at once. Triggers a flush if the buffer reaches
  /// [batchSize] after the addition.
  Future<void> addAll(List<T> items) async {
    _assertNotDisposed();
    _buffer.addAll(items);

    if (_buffer.length >= batchSize) {
      await flush();
    }
  }

  /// Flushes all pending items immediately, regardless of buffer size.
  ///
  /// If the write callback throws, the items remain in the buffer for a
  /// subsequent retry. The error is re-thrown so the caller can decide how
  /// to handle it (e.g., log, show UI warning).
  ///
  /// No-op if the buffer is empty or a flush is already in progress.
  Future<void> flush() async {
    if (_buffer.isEmpty || _flushing) return;

    _flushing = true;

    // Snapshot the current buffer and clear it optimistically. If the write
    // fails we put the items back.
    final batch = List<T>.of(_buffer);
    _buffer.clear();

    try {
      await _writeCallback(batch);
    } catch (error) {
      // Put failed items back at the front so they are retried first.
      _buffer.insertAll(0, batch);
      _flushing = false;
      rethrow;
    }

    _flushing = false;
  }

  /// Discards all pending items without writing them.
  void clear() {
    _assertNotDisposed();
    _buffer.clear();
  }

  /// Flushes remaining items and marks this writer as disposed.
  ///
  /// After disposal, [add], [addAll], [clear], and [flush] will throw.
  /// If the final flush fails, items are silently discarded (the ride is
  /// ending and there's nothing left to retry into).
  Future<void> dispose() async {
    if (_disposed) return;

    try {
      await flush();
    } catch (_) {
      // Best-effort flush on dispose. The ride is ending — if we still
      // can't write, the data is lost. Callers should ensure flush()
      // succeeds before dispose() in critical paths.
    }

    _buffer.clear();
    _disposed = true;
  }

  void _assertNotDisposed() {
    if (_disposed) {
      throw StateError(
        'BatchWriter has been disposed. Create a new instance.',
      );
    }
  }
}
