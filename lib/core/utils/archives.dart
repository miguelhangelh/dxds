
import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<File> compressAndGetFile(File file, String targetPath) async {
  final dir = await path_provider.getTemporaryDirectory();
  Random random = new Random();
  final targetPath = dir.absolute.path + "/temp${random.nextInt(10000).toString()}.jpg";
  final result = await FlutterImageCompress.compressAndGetFile( file.absolute.path, targetPath, quality: 50);

  return result!;
}
Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, targetPath,
    quality: 50,
  );
  //
  // print(file.lengthSync());
  // print(result.lengthSync());

  return result;
}