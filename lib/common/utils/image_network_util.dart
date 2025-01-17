import 'dart:async';

import 'package:flutter/cupertino.dart';

class ImageUtils {
  static Future<ImageInfo> getImageNetworkInfo(String imageUrl) async {
    final Image image = Image.network(imageUrl);
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    image.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info);
          }),
        );
    return completer.future;
  }
}
