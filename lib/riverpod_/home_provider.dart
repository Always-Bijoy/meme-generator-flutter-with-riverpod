import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/components/custom_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final homeProvider =
    ChangeNotifierProvider<HomeProvider>((ref) => HomeProvider());

class HomeProvider with ChangeNotifier {
  File? imagePath;
  File? ssImage;
  String? onChangeText;
  String? onBottomChangeText;
  final GlobalKey globalKey = GlobalKey();
  var rng = Random();

  bool isColorPlatterVisibility = true;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  onValueChanged(value){
    onChangeText = value;
    notifyListeners();
  }
  onBottomValueChanged(value){
    onBottomChangeText = value;
    notifyListeners();
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    pickerColor = color;
    notifyListeners();
  }

  colors(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
            // Use Material color picker:
            //
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   showLabel: true, // only on portrait mode
            // ),
            //
            // Use Block color picker:
            //
            // child: BlockPicker(
            //   pickerColor: currentColor,
            //   onColorChanged: changeColor,
            // ),
            //
            // child: MultipleChoiceBlockPicker(
            //   pickerColors: currentColors,
            //   onColorsChanged: changeColors,
            // ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                currentColor = pickerColor;
                Navigator.of(context).pop();
                notifyListeners();
              },
            ),
          ],
        );
      },
    );
  }

  takeScreenshot() async {
    isColorPlatterVisibility = false;
    notifyListeners();
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    print(pngBytes);
    File imgFile = File('$directory/screenshot${rng.nextInt(200)}.png');
    ssImage = imgFile;
    saveFile(ssImage!);
    imgFile.writeAsBytes(pngBytes);
    notifyListeners();
  }

  saveFile(File file) async {
    await askPermission();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()));
    print(result);
  }

  askPermission() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.photos].request();
  }

  Future<dynamic> attachedImage(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogImagePicker(
          onCameraClick: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                maxHeight: 300,
                maxWidth: 300,
                imageQuality: 90);
            imagePath = File(image!.path);
            notifyListeners();
            if (kDebugMode) {
              print(File(image.path));
            }
          },
          onGalleryClick: () async {
            final ImagePicker pickerGallery = ImagePicker();
            final XFile? imageGallery = await pickerGallery.pickImage(
                source: ImageSource.gallery,
                maxHeight: 300,
                maxWidth: 300,
                imageQuality: 90);
            imagePath = File(imageGallery!.path);
            notifyListeners();

            if (kDebugMode) {
              print(File(imageGallery.path));
            }
          },
        );
      },
    );
  }
}
