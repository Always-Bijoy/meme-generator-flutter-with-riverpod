import 'package:flutter/material.dart';

class CustomDialogImagePicker extends StatelessWidget {
  final Function? onCameraClick;
  final Function? onGalleryClick;

  const CustomDialogImagePicker(
      {Key? key, this.onCameraClick, this.onGalleryClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Image'),
      content: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              if (onCameraClick != null) onCameraClick!();
            },
            icon: const Icon(Icons.camera),
            label: const Text('Camera'),
          ),
          const SizedBox(width: 10,),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              if (onGalleryClick != null) onGalleryClick!();
            },
            icon: const Icon(Icons.image),
            label: const Text('Gallery'),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
