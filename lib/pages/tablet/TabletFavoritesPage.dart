import 'package:e6b_flutter/pages/phone/FavoritesList.dart';
import 'package:flutter/material.dart';

class TabletFovoritesPage extends StatefulWidget {
  const TabletFovoritesPage({super.key});

  @override
  State<TabletFovoritesPage> createState() => _TabletFovoritesPageState();
}

class _TabletFovoritesPageState extends State<TabletFovoritesPage> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 350,
          child: FavoritesList(),
        ),
        VerticalDivider(width: 1),
        Expanded(child: Center(child: Text("calculator selected"))),
      ],
    );
  }
}
