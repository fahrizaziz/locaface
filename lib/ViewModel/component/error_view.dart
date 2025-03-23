import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorView extends StatelessWidget {
  final GoException? error;
  const ErrorView({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('An error occurred: ${error.toString()}')),
    );
  }
}
