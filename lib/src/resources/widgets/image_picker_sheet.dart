import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSheet extends StatelessWidget {
  final ValueChanged<List<String?>> onImagesPicked;
  final bool isMultiple;

  const ImagePickerSheet({
    super.key,
    required this.onImagesPicked,
    this.isMultiple = false,
  });

  Future<void> _pickImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    if (isMultiple) {
      final List<XFile> images = await picker.pickMultiImage();
      onImagesPicked(images.map((image) => image.path).toList());
        } else {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        onImagesPicked([image.path]);
      }
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      onImagesPicked([image.path]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () => _pickImages(context),
            child: Text(
              isMultiple ? "Pick Multiple Images" : "Pick an Image",
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () => _takePhoto(context),
            child: const Text(
              "Take Photo",
            ),
          ),
        ],
      ),
    );
  }
}
