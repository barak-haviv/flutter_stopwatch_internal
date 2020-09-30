import 'dart:async';
import 'dart:isolate';

class StopWatch {
  bool _isRunning = false;
  bool _isPaused = false;
  int _ticks = 0;
  StreamController<int> _controller;
  Isolate isolate;
  StreamSubscription _subscription;

  bool get isPaused => _isPaused;
  bool get isRunning => _isRunning;
  int get ticks => _ticks;

  void subscribe(Function onTimeChange) async {
    _controller = StreamController<int>();
    _subscription = _controller.stream.listen(onTimeChange);
  }

  void unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void start() async {
    this._isPaused = false;
    this._isRunning = true;
    ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(_runTimer, receivePort.sendPort);
    receivePort.listen(this._onTick);
  }

  void pause() {
    this._isPaused = true;
    _killIsolate();
  }

  void stop() {
    this._isPaused = false;
    _killIsolate();
    this._ticks = 0;
    _controller.add(this._ticks);
  }

  static void _runTimer(SendPort sendPort) {
    int counter = 0;
    Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
      counter += 10;
      String msg = 'notification ' + counter.toString();
      //print('SEND: ' + msg + ' - ');
      sendPort.send(counter);
    });
  }

  void _onTick(data) {
    print('onTick $data ${_ticks.toString()}');
    if (!this._isRunning) {
      return;
    }
    this._ticks += 10;
    _controller.add(this._ticks);
  }

  void _killIsolate() {
    _isRunning = false;
    if (isolate != null) {
      print('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
