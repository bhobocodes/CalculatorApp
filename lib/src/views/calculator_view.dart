import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/calculator_view_model.dart';
import 'widgets/calculator_button.dart';
import 'widgets/calculator_text.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  late TextEditingController aController;
  late TextEditingController bController;

  late FocusNode firstFocus;
  late FocusNode secondFocus;

  bool isFirstSelected = true;

  String selectedOperator = "";
  int selectedIndex = -1;

  final _formKey = GlobalKey<FormState>();


  final List<String> buttons = [
    "AC",
    "*",
    "%",
    "÷",
    "7",
    "8",
    "9",
    "-",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    ".",
    "0",
  ];

  void appendNumber(String value) {
    setState(() {
      if (isFirstSelected) {
        aController.text = aController.text + value;
      } else {
        bController.text = bController.text + value;
      }
    });

    _formKey.currentState?.validate();
  }

  @override
  void initState() {
    super.initState();
    aController = TextEditingController();
    bController = TextEditingController();

    firstFocus = FocusNode();
    secondFocus = FocusNode();
  }

  @override
  void dispose() {
    aController.dispose();
    bController.dispose();

    firstFocus.dispose();
    secondFocus.dispose();

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
                builder: (_) {
                  return Consumer<CalculatorViewModel>(
                    builder: (context, vm, child) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text(
                              "History",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: vm.clearHistory,
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.blueGrey,
                                ),
                                label: const Text(
                                  "Delete All",
                                  style: TextStyle(color: Colors.lightGreen),
                                ),
                              ),
                            ),

                            Expanded(
                              child: vm.history.isEmpty
                                  ? const Center(child: Text("No history yet"))
                                  : ListView.builder(
                                      itemCount: vm.history.length,
                                      itemBuilder: (context, index) {
                                        final item = vm.history[index];

                                        return ListTile(
                                          leading: const Icon(Icons.history),
                                          title: Text(item.expression),
                                          subtitle: Text(
                                            "Result: ${item.result}",
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.greenAccent,
                                            ),
                                            onPressed: () {
                                              vm.deleteHistory(index);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ================= FIRST INPUT =================
                      CalculatorTextField(
                        controller: aController,
                        focusNode: firstFocus,
                        label: "First number",

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter first number";
                          }
                          return null;
                        },

                        onTap: () {
                          setState(() {
                            isFirstSelected = true;
                            selectedIndex = -1;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // ================= Second INPUT ===========
                      CalculatorTextField(
                        controller: bController,
                        focusNode: secondFocus,
                        label: "Second number",

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter second number";
                          }
                          return null;
                        },

                        onTap: () {
                          setState(() {
                            isFirstSelected = false;
                            selectedIndex = -1;
                          });
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
                        child: LayoutBuilder(
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                                          ? Colors.green.withOpacity(
                                              0.4,
                                            ) // highlight color
                                          : Colors
                                                .grey
                                                .shade300, // fixed base color
                                      onTap: () {
                                        if (value.trim() == "AC") {
                                          setState(() {
                                            aController.clear();
                                            bController.clear();
                                            selectedIndex = index;
                                            isFirstSelected = true;
                                          });

                                          FocusScope.of(context).unfocus();
                                          return;
                                        }

                                        // highlight ALWAYS first
                                        setState(() {
                                          selectedIndex = index;
                                        });

                                        if ([
                                          "+",
                                          "-",
                                          "×",
                                          "÷",
                                          "%",
                                        ].contains(value)) {
                                          if (!_formKey.currentState!
                                              .validate())
                                            return;

                                          final a = double.parse(
                                            aController.text,
                                          );
                                          final b = double.parse(
                                            bController.text,
                                          );

                                          switch (value) {
                                            case "+":
                                              viewModel.add(a, b);
                                              break;
                                            case "-":
                                              viewModel.subtract(a, b);
                                              break;
                                            case "×":
                                              viewModel.multiply(a, b);
                                              break;
                                            case "÷":
                                              viewModel.divide(a, b);
                                              break;
                                            case "%":
                                              viewModel.modulus(a, b);
                                              break;
                                          }
                                        } else {
                                          appendNumber(value);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
