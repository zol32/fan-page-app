import 'package:flutter/material.dart';
import 'package:myfanpage/services/auth/cloud_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final CloudService _cloudService = CloudService();

  late final TextEditingController _imageUrl;
  late final TextEditingController _caption;

  @override
  void initState() {
    _imageUrl = TextEditingController();
    _caption = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _imageUrl.dispose();
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _imageUrl,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter image url',
            ),
          ),
          TextField(
            controller: _caption,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter caption',
            ),
          ),
          TextButton(
            onPressed: () async {
              final imageUrl = _imageUrl.text;
              final caption = _caption.text;
              await _cloudService.createPost(imageUrl, caption);
              Navigator.of(context).pop();
            },
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }
}
