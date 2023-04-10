import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultPage extends ConsumerStatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends ConsumerState<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Default Page')
          ],)
      )
    );
  } 
}