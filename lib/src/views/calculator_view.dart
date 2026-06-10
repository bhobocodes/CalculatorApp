import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/calculator_view_model.dart';
import 'widgets/calculator_button.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {

  late TextEditingController aController;
  late TextEditingController bController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    aController = TextEditingController();
    bController = TextEditingController();
  }

  @override
  void dispose() {
    aController.dispose();
    bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalculatorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator App"),
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
                              child: IconButton(
                                onPressed: vm.clearHistory,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),

                            Expanded(
                              child: vm.history.isEmpty
                                  ? const Center(
                                child: Text("No history yet"),
                              )
                                  : ListView.builder(
                                itemCount: vm.history.length,
                                itemBuilder: (context, index) {
                                  final item = vm.history[index];

                                  return ListTile(
                                    leading: const Icon(Icons.history),
                                    title: Text(item.expression),
                                    subtitle:
                                    Text("Result: ${item.result}"),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ================= FIRST INPUT =================
                TextFormField(
                  controller: aController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "First number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter first number"; // used key validator
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // ================= SECOND INPUT =================
                TextFormField(
                  controller: bController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Second number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter second number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // ================= BUTTONS =================

                Expanded(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [

                      CalcButton(
                        text: "AC",
                        textColor: Colors.red,
                        onTap: () {
                          aController.clear();
                          bController.clear();
                        },
                      ),

                      CalcButton(
                        text: "×",
                        textColor: Colors.indigo,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.multiply(
                              double.parse(aController.text),
                              double.parse(bController.text),
                            );
                          }
                        },
                      ),

                      CalcButton(
                        text: "%",
                        textColor: Colors.indigo,
                        onTap: () {},
                      ),

                      CalcButton(
                        text: "÷",
                        textColor: Colors.indigo,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.divide(
                              double.parse(aController.text),
                              double.parse(bController.text),
                            );
                          }
                        },
                      ),

                      CalcButton(text: "7"),
                      CalcButton(text: "8"),
                      CalcButton(text: "9"),

                      CalcButton(
                        text: "×",
                        textColor: Colors.indigo,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.multiply(
                              double.parse(aController.text),
                              double.parse(bController.text),
                            );
                          }
                        },
                      ),

                      CalcButton(text: "4"),
                      CalcButton(text: "5"),
                      CalcButton(text: "6"),

                      CalcButton(
                        text: "-",
                        textColor: Colors.indigo,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.subtract(
                              double.parse(aController.text),
                              double.parse(bController.text),
                            );
                          }
                        },
                      ),

                      CalcButton(text: "1"),
                      CalcButton(text: "2"),
                      CalcButton(text: "3"),

                      CalcButton(
                        text: "+",
                        textColor: Colors.indigo,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.add(
                              double.parse(aController.text),
                              double.parse(bController.text),
                            );
                          }
                        },
                      ),

                      CalcButton(text: "0"),

                      CalcButton(text: "."),

                      CalcButton(
                        text: "=",
                        textColor: Colors.white,
                        backgroundColor: Colors.indigo,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.add(
                              double.parse(aController.text),
                              double.parse(bController.text),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ================= RESULT =================
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Result : ${viewModel.result}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
