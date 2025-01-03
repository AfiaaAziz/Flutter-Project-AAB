import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore (a cloud database for storing details like the names and descriptions of images).


class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> _selectedImages = [];
  String? _selectedCategory;
  bool _isUploading = false;

  final supabase = Supabase.instance.client;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _categories = ["Casual", "Events", "Prayer", "Kaftan"];

  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages = pickedFiles.map((file) {
            return {
              'file': File(file.path),
              'fileName': '',
              'description': '',
            };
          }).toList();
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick images: $e');
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      _showSnackBar('Please select images first.');
      return;
    }
    if (_selectedCategory == null) {
      _showSnackBar('Please select a category.');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final categoryCollection = _firestore.collection(_selectedCategory!);

      for (var imageData in _selectedImages) {
        final image = imageData['file'] as File;
        final fileName = imageData['fileName'] as String;
        final description = imageData['description'] as String;

        if (fileName.isEmpty || description.isEmpty) {
          _showSnackBar(
              'Please provide a filename and description for all images.');
          setState(() {
            _isUploading = false;
          });
          return;
        }

        final fileBytes = await image.readAsBytes();

        final filePath = '${_selectedCategory!}/$fileName';

        final response = await supabase.storage
            .from('FlutterProject')
            .uploadBinary(filePath, fileBytes);

        if (response.isNotEmpty) {
          final publicUrl = supabase.storage
              .from('FlutterProject')
              .getPublicUrl(filePath);

          await categoryCollection.add({
            'fileName': fileName,
            'description': description,
            'imageUrl': publicUrl,
            'uploadedAt': Timestamp.now(),
            'isLiked': false,
          });
        }
      }

      setState(() {
        _isUploading = false;
        _selectedImages.clear();
        _selectedCategory = null;
      });

      _showSnackBar('Images uploaded successfully!');
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showSnackBar('Failed to upload images: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Admin Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              value: _selectedCategory,
              hint: const Text("Select Category"),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: _categories
                  .map((category) =>
                  DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            if (_selectedImages.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    final imageData = _selectedImages[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.file(
                              imageData['file'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter File Name',
                              ),
                              onChanged: (value) {
                                _selectedImages[index]['fileName'] = value;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter Description',
                              ),
                              onChanged: (value) {
                                _selectedImages[index]['description'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton.icon(
              onPressed: () => _pickImages(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                backgroundColor: Colors.black,
                // Black button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                shadowColor: Colors.black.withOpacity(0.4),
                elevation: 5,
              ),
              label: const Text('Select Images',style: TextStyle(color: Colors.white),),
              icon: const Icon(Icons.photo_library,color: Colors.white),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _isUploading ? null : _uploadImages(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                backgroundColor: Colors.black,
                // Black button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.black.withOpacity(0.4),
                elevation: 5,
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Upload Images',style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}