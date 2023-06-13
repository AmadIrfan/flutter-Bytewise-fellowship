import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String text;

  const ImagePreviewScreen(
      {super.key, required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("$text Photo"),
      ),
      body: SizedBox(
        width: size.width * 1,
        height: size.height * 0.960,
        child: imageUrl.isNotEmpty
            ? PhotoView(
                filterQuality: FilterQuality.high,
                backgroundDecoration: const BoxDecoration(color: Colors.grey),
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 1,
              )
            : PhotoView(
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                imageProvider: const AssetImage('Assets/Logo/logo.png'),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
      ),
    );
  }
}
