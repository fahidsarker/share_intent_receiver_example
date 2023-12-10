import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentReceiver {
  static late final StreamSubscription _intentDataStreamSubscription;
  static late final StreamSubscription _intentTextStreamSubscription;


  static void init(void Function(String?, List<SharedMediaFile>) callback) async{
    final initText = await ReceiveSharingIntent.getInitialText();
    final initMedia = await ReceiveSharingIntent.getInitialMedia();
    if (initText != null || initMedia.isNotEmpty) {
      callback(initText, initMedia);
    }
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      callback(null, value);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    _intentTextStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      callback(value, []);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });
  }

  static void cancel () {
    _intentDataStreamSubscription.cancel();
    _intentTextStreamSubscription.cancel();
  }
}