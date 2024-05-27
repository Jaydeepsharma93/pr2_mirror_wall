import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('History Pages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: Provider.of<MainProvider>(context).historylist.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Provider.of<MainProvider>(context).historylist[index]),
            );
          },
        ),
      ),
    );
  }
}
