import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_roll/utils/admin_colors.dart';

class ImageUpload extends StatefulWidget {
  final VoidCallback onImageUploaded; // Callback for image upload

  const ImageUpload({super.key, required this.onImageUploaded});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _clientImage;
  String? _encodedImage;
  Image? _decodedImage;
  String? _resultMessage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _clientImage = File(pickedFile.path);
        _encodeImageToJson(); // Encode the image to base64 after selecting
        _resultMessage = 'Image selected successfully';
      });
    }
  }

  Future<void> _encodeImageToJson() async {
    if (_clientImage == null) return;

    final bytes = await _clientImage!.readAsBytes();
    _encodedImage = base64Encode(bytes);

    setState(() {
      _resultMessage = 'Image encoded successfully';
    });
  }

  Future<void> _decodeImageFromJson(String base64String) async {
    if (base64String.isEmpty) return;

    try {
      final Uint8List bytes = base64Decode(base64String);

      setState(() {
        _decodedImage = Image.memory(bytes);
        _resultMessage = 'Image decoded successfully';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Failed to decode image: $e';
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadAndReturnImage() async {
    if (_encodedImage == null) {
      setState(() {
        _resultMessage = 'Please select and encode an image';
      });
      return;
    }

    setState(() {
      _resultMessage = 'Image Uploaded Successfully';
    });

    widget.onImageUploaded(); // Notify that the image has been uploaded
    Navigator.pop(context,
        _encodedImage); // Return the encoded image data to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9, // Make the container responsive
          padding:
              const EdgeInsets.all(16.0), // Add padding inside the container
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 185, 185, 185), // Border color
              width: 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Gray shadow
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            gradient: const LinearGradient(
              colors: [
                AppColors.charcoalGray,
                AppColors.charcoalGray,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _clientImage != null
                    ? Container(
                        margin: const EdgeInsets.only(
                            bottom: 16.0), // Margin below the image
                        child: Image.file(
                          _clientImage!,
                          height: screenHeight * 0.3,
                          width: screenWidth *
                              0.9, // Adjust width for responsiveness
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(
                            bottom: 16.0), // Margin below the text
                        child: const Text(
                          'Please Upload Image By Selecting an Image',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                ElevatedButton(
                  onPressed: _showImageSourceDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.lightSkyBlue, // Button background color
                    foregroundColor:
                        AppColors.babyBlue, // Text color (foreground)
                  ),
                  child: const Text('Select Image'),
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightSkyBlue,
                    foregroundColor: AppColors.babyBlue,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.010,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _uploadAndReturnImage,
                  child: const Text('Ok'),
                ),
                SizedBox(height: screenHeight * 0.03),
                if (_resultMessage != null)
                  Text(
                    _resultMessage!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
