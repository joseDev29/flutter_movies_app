import 'dart:async';

class Debouncer<T> {
  Debouncer({required this.duration, this.onValue});

  final Duration duration;

  void Function(T value)? onValue;

  Timer? _timer;

  void nextValue(T value) {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(duration, () => onValue!(value));
  }
}
