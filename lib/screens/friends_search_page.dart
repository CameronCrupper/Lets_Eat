import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendSearchPage extends ConsumerStatefulWidget {
  const FriendSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends ConsumerState<FriendSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Find some friends')
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Search For Friends')
            ],
          )
        )
      )
    );
  } 
}