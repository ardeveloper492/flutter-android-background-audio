import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

Telephony telephony = Telephony.instance;
AudioHandler _audioHandler;

const String _portName = "my_audio_handler";

Future<void> main() async {
  _audioHandler = await AudioService.init(
    builder: () => IsolatedAudioHandler(
      AudioPlayerHandler(),
      portName: _portName,
    ),
  );

  telephony.listenIncomingSms(onNewMessage: onNewMessage, onBackgroundMessage: onBackgroundMessage);

  runApp(MyApp());
}

Future<void> onBackgroundMessage(SmsMessage message) async {
  print("onBackgroundMessage");

  var proxyAudioHandler = await IsolatedAudioHandler.lookup(
    portName: _portName,
  );
  await proxyAudioHandler.play();
}

Future<void> onNewMessage(SmsMessage message) async {
  print("onNewMessage");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(child: Text("Test")),
    );
  }
}

class AudioPlayerHandler extends BaseAudioHandler {
  @override
  Future<void> play() async {
    print("PLAY");
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> seek(Duration position) async {}
  @override
  Future<void> skipToQueueItem(int i) async {}
}
