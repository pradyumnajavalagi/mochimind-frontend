import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../models/flashcard_model.dart';
import '../services/api_service.dart';

class AddEditPage extends StatefulWidget {
  final Flashcard? card;
  const AddEditPage({super.key, this.card});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController onyomiCtrl, kunyomiCtrl, exampleCtrl;
  String? imageUrl;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.card?.kanjiImageUrl;
    onyomiCtrl = TextEditingController(text: widget.card?.onyomi);
    kunyomiCtrl = TextEditingController(text: widget.card?.kunyomi);
    exampleCtrl = TextEditingController(text: widget.card?.exampleUsage);
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => pickedImage = File(picked.path)); // ✅ Local preview

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8080/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      picked.path,
      filename: path.basename(picked.path),
    ));

    final res = await request.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      setState(() {
        imageUrl = resBody; // ✅ Backend URL
        pickedImage = null; // clear File once uploaded, so we show the URL instead
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload image")),
      );
    }
  }

  void save() async {
    if (!_formKey.currentState!.validate() || imageUrl == null) return;

    final newCard = Flashcard(
      id: widget.card?.id ?? 0,
      kanjiImageUrl: imageUrl!,
      onyomi: onyomiCtrl.text,
      kunyomi: kunyomiCtrl.text,
      exampleUsage: exampleCtrl.text,
    );

    if (widget.card == null) {
      await ApiService.createFlashcard(newCard);
    } else {
      await ApiService.updateFlashcard(newCard);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.card == null ? "Add Flashcard" : "Edit Flashcard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (pickedImage != null)
                Image.file(pickedImage!, height: 160)
              else if (imageUrl != null && imageUrl!.isNotEmpty)
                Image.network(imageUrl!, height: 160)
              else
                const Placeholder(fallbackHeight: 160),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickAndUploadImage,
                icon: const Icon(Icons.upload),
                label: const Text("Pick Kanji Image"),
              ),
              TextFormField(controller: onyomiCtrl, decoration: const InputDecoration(labelText: "Onyomi")),
              TextFormField(controller: kunyomiCtrl, decoration: const InputDecoration(labelText: "Kunyomi")),
              TextFormField(controller: exampleCtrl, decoration: const InputDecoration(labelText: "Example Usage")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: save, child: const Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
