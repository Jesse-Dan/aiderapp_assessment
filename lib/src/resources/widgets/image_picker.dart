import 'dart:developer' as developer;
import 'dart:io';

import 'package:do_it_now/src/resources/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/cloudinary/cloudinary_service.dart';
import '../utils/show_text.dart';
import 'app_loading_indicator.dart';
import 'image_viewer.dart';

enum UploadMode { single, multiple }

class AppImagePicker extends ConsumerStatefulWidget {
  const AppImagePicker({
    super.key,
    required this.onUploadComplete,
    this.mode = UploadMode.single,
    this.maxFiles,
    this.initialPaths = const [],
    this.readOnly = false,
  });

  final Function(List<String>) onUploadComplete;
  final UploadMode mode;
  final int? maxFiles;
  final List<String> initialPaths;
  final bool readOnly;

  @override
  // ignore: library_private_types_in_public_api
  _AppImagePickerState createState() => _AppImagePickerState();
}

class _AppImagePickerState extends ConsumerState<AppImagePicker> {
  late List<String> _uploadedPaths;
  final _cloudinaryService = CloudinaryService.instance;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _uploadedPaths = widget.initialPaths;
    developer
        .log('AppImagePicker initialized with initial paths: $_uploadedPaths');
  }

  bool get _canUploadMore {
    if (widget.mode == UploadMode.single) return false;
    if (widget.maxFiles == null) return true;
    return _uploadedPaths.length < widget.maxFiles!;
  }

  Future<void> _uploadImages(List<XFile> files) async {
    if (files.isEmpty) {
      developer.log('No valid files to upload');
      return;
    }

    setState(() => _isUploading = true);
    developer.log('Starting image upload process...');
    try {
      for (final file in files) {
        developer.log('Uploading file: ${file.path}');
        var url = '';
        url = await _cloudinaryService.uploadFile(file: File(file.path));
        developer.log('File uploaded successfully. URL: $url');

        setState(() {
          if (widget.mode == UploadMode.single) {
            _uploadedPaths = [url];
          } else {
            _uploadedPaths = [..._uploadedPaths, url];
          }
        });
      }
      widget.onUploadComplete(_uploadedPaths);
      developer.log('Upload complete. Updated paths: $_uploadedPaths');
    } catch (e) {
      developer.log('Upload failed: $e', error: e);
      showText('Upload failed: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
      developer.log('Upload process completed.');
    }
  }

  void _handleRemove(int index) {
    if (widget.readOnly) {
      showText("This field is marked as read-only");
      return;
    }
    developer.log('Removing file at index: $index');
    setState(() => _uploadedPaths.removeAt(index));
    widget.onUploadComplete(_uploadedPaths);
    developer.log('File removed. Updated paths: $_uploadedPaths');
  }

  Future<void> _pickImages() async {
    if (widget.readOnly) {
      showText("This field is marked as read-only");
      return;
    }

    developer.log('Initiating image picker...');
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                text: "Pick from Gallery",
              ),
              const SizedBox(height: 10),
              AppButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                text: "Take a Photo",
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      developer.log('Image source selection canceled.');
      return;
    }

    try {
      final files =
          widget.mode == UploadMode.multiple && source == ImageSource.gallery
              ? await picker.pickMultiImage(imageQuality: 85)
              : [
                  await picker.pickImage(source: source, imageQuality: 85),
                ];

      final validFiles =
          files.where((file) => file != null).cast<XFile>().toList();

      if (validFiles.isNotEmpty) {
        developer.log('${validFiles.length} files selected for upload.');
        await _uploadImages(validFiles);
      } else {
        developer.log('No files selected or selection canceled.');
      }
    } catch (e) {
      developer.log('Error during image selection: $e', error: e);
      showText('Error selecting images: ${e.toString()}');
    }
  }

  Widget _buildSingleUpload() {
    return Column(
      children: [
        if (_uploadedPaths.isNotEmpty)
          Stack(
            children: [
              AppImageViewer(
                _uploadedPaths.first,
                height: 200,
                width: double.infinity,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _handleRemove(0),
                ),
              ),
            ],
          )
        else
          const Icon(Icons.image, size: 100),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: _isUploading ? null : _pickImages,
            text: _uploadedPaths.isEmpty ? 'Upload Image' : 'Replace Image',
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleUpload() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _uploadedPaths.asMap().entries.map((entry) {
            return Stack(
              children: [
                AppImageViewer(
                  entry.value,
                  height: 100,
                  width: 100,
                  borderRadius: BorderRadius.circular(8),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _handleRemove(entry.key),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(Icons.close,
                          size: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        if (_canUploadMore) ...[
          const SizedBox(height: 16),
          AppButton(
            onPressed: _isUploading ? null : _pickImages,
            text: 'Add More Images',
          ),
        ],
        if (widget.maxFiles != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${_uploadedPaths.length}/${widget.maxFiles} files uploaded',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    developer.log('Building AppImagePicker UI');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _isUploading
          ? const Center(child: AppLoadingIndicator())
          : widget.mode == UploadMode.single
              ? _buildSingleUpload()
              : _buildMultipleUpload(),
    );
  }
}
