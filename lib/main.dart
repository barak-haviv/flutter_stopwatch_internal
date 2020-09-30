import 'package:background_job/stopwatch.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TabBarDemo());
}

List<StopWatch> stopWatches = [
  StopWatch(),
  StopWatch(),
  StopWatch(),
];

class StopWatchWidget extends StatefulWidget {
  final StopWatch stopWatch;
  StopWatchWidget({Key key, this.stopWatch}) : super(key: key);

  @override
  _StopWatchWidgetState createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  String _timeToDisplay;

  @override
  void initState() {
    super.initState();
    print('init ontimechange $this.onTimeChange');
    widget.stopWatch.subscribe(this.onTimeChange);
    _timeToDisplay = widget.stopWatch.ticks.toString();
  }

  onTimeChange(ticks) {
    print('message: ${ticks.toString()}');
    setState(() {
      _timeToDisplay = ticks.toString();
    });
  }

  @override
  void dispose() {
    widget.stopWatch.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_timeToDisplay),
        RaisedButton(
          child: Text(widget.stopWatch.isRunning ? 'Stop' : 'Start'),
          onPressed: () {
            if (widget.stopWatch.isRunning) {
              widget.stopWatch.stop();
            } else {
              widget.stopWatch.start();
            }
            setState(() {});
          },
        ),
        if (widget.stopWatch.isRunning)
          RaisedButton(
            child: Text('Pause'),
            onPressed: () {
              if (widget.stopWatch.isRunning) {
                widget.stopWatch.pause();
              } else {
                widget.stopWatch.start();
              }
              setState(() {});
            },
          )
      ],
    );
  }
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              StopWatchWidget(stopWatch: stopWatches[0]),
              StopWatchWidget(stopWatch: stopWatches[1]),
              StopWatchWidget(stopWatch: stopWatches[2]),
            ],
          ),
        ),
      ),
    );
  }
}
