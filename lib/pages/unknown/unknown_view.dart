import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_pages.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage(GoException? error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('THE ROUTE WAS NOT FOUND')),
      body: ListTile(
        title: const Text('BACK TO HOMEPAGE'),
        subtitle: const Text('BACK TO HOMEPAGE'),
        onTap: () => context.go(Paths.home),
      ),
    );
  }
}
