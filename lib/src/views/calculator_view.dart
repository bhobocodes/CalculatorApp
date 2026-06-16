import 'package:calculator_project/src/views/widgets/history_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/calculator_view_model.dart';
import 'widgets/calculator_button.dart';
import 'widgets/calculator_text.dart';
import 'widgets/calculator_button_grid.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  int selectedIndex = -1;
  int openBracket = 0;
  final TextEditingController _controller = TextEditingController();

  String expression = "";

  final List<String> buttons = [
    "AC", "(", ")", "÷",
    "7", "8", "9", "×",
    "4", "5", "6", "-",
    "1", "2", "3", "+",
    "0", ".", "=", "%",
  ];

  void appendValue(String value) {
    setState(() {
      expression += value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalculatorViewModel>();

    return Scaffold(
      appBar: AppBar(
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
      ),

      // ✅ ONLY ONE BODY (fixed)
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();

            setState(() {
              selectedIndex = -1;
            });
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 15),

                    // ================= INPUT =================
                    TextField(
                      controller: _controller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter expression...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        expression = value;
                      },
                    ),

                    const SizedBox(height: 15),

                    // ================= RESULT =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Result : ${viewModel.result}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ================= BUTTONS =================
                    Expanded(
                      child: CalculatorButtonGrid(
                        buttons: buttons,
                        selectedIndex: selectedIndex,
                        onTap: (value, index) {

                          if (value == "=") {
                            while (openBracket > 0) {
                              expression += ")";
                              openBracket--;
                            }

                            viewModel.calculateExpression(
                              expression,
                            );
                            return;
                          }

                          if (value == "AC") {
                            setState(() {
                              expression = "";
                              openBracket = 0;
                              selectedIndex = index;
                              _controller.clear();
                            });

                            viewModel.clear();
                            return;
                          }

                          setState(() {
                            if (value == "(") {
                              openBracket++;
                              expression += value;
                            } else if (value == ")") {
                              if (openBracket > 0) {
                                openBracket--;
                                expression += value;
                              }
                            } else {
                              expression += value;
                            }

                            _controller.text = expression;

                            _controller.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                    offset: _controller.text.length,
                                  ),
                                );
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
