import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ThumbnailProvider.g.dart';

@riverpod
Future<String?> thumbnail(ThumbnailRef ref, String path) async {
  ref.keepAlive();

  return await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 100);
}
