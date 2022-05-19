import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  SmartlookRenderingMode _renderingMode = SmartlookRenderingMode.native;

  @override
  void initState() {
    super.initState();
    initSmartlook();
  }

  Future<void> initSmartlook() async {
    await Smartlook.setupAndStartRecording(
      SetupOptionsBuilder('PUT_YOUR_API_TOKEN_HERE').build(),
    );
    await Smartlook.setUserIdentifier('wireframe error repro');
    Smartlook.setRenderingMode(_renderingMode);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> switchRenderingMode(SmartlookRenderingMode mode) async {
    await Smartlook.trackCustomEvent('recording mode changed', {
      'mode': mode.toString(),
    });
    await Smartlook.setRenderingMode(mode);
    setState(() {
      _renderingMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.primaries[_counter % Colors.primaries.length],
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text('$_renderingMode'),
            ],
          ),
        ),
        floatingActionButton: Wrap(
          spacing: 8,
          children: [
            FloatingActionButton(
              onPressed: () =>
                  switchRenderingMode(SmartlookRenderingMode.wireframe),
              tooltip: 'Enable wireframe',
              child: const Icon(Icons.construction_rounded),
            ),
            FloatingActionButton(
              onPressed: () =>
                  switchRenderingMode(SmartlookRenderingMode.native),
              tooltip: 'Enable native',
              child: const Icon(Icons.phone_android_rounded),
            ),
            FloatingActionButton(
              onPressed: () =>
                  switchRenderingMode(SmartlookRenderingMode.no_rendering),
              tooltip: 'Enable no_rendering',
              child: const Icon(Icons.do_disturb_alt_rounded),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
}
