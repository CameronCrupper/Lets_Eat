import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartTablePage extends ConsumerStatefulWidget {
  const StartTablePage({Key? key}) : super(key: key);

  @override
  ConsumerState<StartTablePage> createState() => _StartTablePageState();
}

class _StartTablePageState extends ConsumerState<StartTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('New Table')
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Start a new Table')
            ],
          )
        )
      )
    );
  } 
}