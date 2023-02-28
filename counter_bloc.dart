import 'dart:async';

class CounterBloc {
  int count = 0;

  // Sending value to Stream
  final StreamController<int> _counterController = StreamController<int>();

  // Expose value to StreamBuilder
  Stream<int> get counterStream => _counterController.stream;

  Count(int value) {
    _counterController.sink.add(count = value);
  }

  decrementCounter() {
    _counterController.sink.add(count--);
  }

  void dispose() {
    _counterController.close();
  }
}
