import 'package:flutter/material.dart';
import 'calculator_button.dart';

class CalculatorButtonGrid extends StatelessWidget {
  final List<String> buttons;
  final int selectedIndex;
  final Function(String value, int index) onTap;

  const CalculatorButtonGrid({
    super.key,
    required this.buttons,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount = 4;

        if (width > 1200) {
          crossAxisCount = 6;
        } else if (width > 800) {
          crossAxisCount = 5;
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),
            child: GridView.builder(
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (context, index) {
                final value = buttons[index];

                return CalcButton(
                  text: value,
                  color: selectedIndex == index
                      ? Colors.green.withOpacity(.4)
                      : Colors.grey.shade300,
                  onTap: () {
                    onTap(value, index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}