// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageView extends ConsumerWidget {
  final String imageUrl;
  const ImageView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Image.network(imageUrl),
          ),
          70.sbH,
        ],
      ),
    );
  }
}
