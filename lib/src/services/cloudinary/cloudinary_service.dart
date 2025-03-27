import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = 'dch8zvohv';
  static const String _apiKey = '528266984753781';
  static const String _uploadPreset = 'Digitwhale';

  static void initialize() {
    _instance = _instance ??= CloudinaryService._();
  }

  static CloudinaryService? _instance;

  CloudinaryService._();

  static CloudinaryService get instance => _instance!;

  /// Upload a file to Cloudinary using HTTP POST
  Future<String> uploadFile({
    required File file,
    String? publicId,
  }) async {
    if (!file.existsSync()) {
      throw Exception('File does not exist: ${file.path}');
    }

    developer.log('Starting file upload to Cloudinary...');
    developer.log('File: ${file.path}');
    developer.log('Public ID: $publicId');

    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/upload',
      );

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['api_key'] = _apiKey
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      if (publicId != null) {
        request.fields['public_id'] = publicId;
      }

      developer.log('Sending upload request...');
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        developer.log('File uploaded successfully: $jsonResponse');
        return jsonResponse['secure_url'];
      } else {
        throw Exception('Upload failed: ${jsonResponse['error']['message']}');
      }
    } catch (e) {
      developer.log('Error during file upload: $e', error: e);
      rethrow;
    }
  }

  /// Upload multiple files to Cloudinary
  Future<List<String>> uploadFiles({
    required List<File> files,
    String? folder,
  }) async {
    developer.log('Starting multiple file upload...');
    final List<String> urls = [];

    try {
      for (final file in files) {
        final url = await uploadFile(file: file);
        urls.add(url);
      }
      developer.log('All files uploaded successfully');
      return urls;
    } catch (e) {
      developer.log('Error during bulk upload: $e', error: e);
      rethrow;
    }
  }
}
