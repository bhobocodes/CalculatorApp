import 'package:flutter/material.dart';
import 'history_bottom_sheet.dart';

class CalculatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CalculatorAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calculate),
          SizedBox(width: 8),
          Text("Calculator App"),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const HistoryBottomSheet(),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}