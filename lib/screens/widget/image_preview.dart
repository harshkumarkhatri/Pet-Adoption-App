import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final Widget image;
  final String petName;

  const ImagePreview({
    Key? key,
    required this.image,
    required this.petName,
  }) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.petName,
          ),
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: InteractiveViewer(
          child: Center(
            child: widget.image,
          ),
        ));
  }
}
