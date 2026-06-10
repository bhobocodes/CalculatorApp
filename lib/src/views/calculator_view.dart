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

  bool isFirstSelected = true;

  String selectedOperator = "";

  final _formKey = GlobalKey<FormState>();

  final List<String> buttons = [
    "AC","÷","%","×",
    "7","8","9","×",
    "4","5","6","-",
    "1","2","3","+",
    "0",".","=",""
  ];

  void appendNumber(String value) {
    if (isFirstSelected) {
      aController.text += value;
    } else {
      bController.text += value;
    }

    setState(() {});
  }


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
        child: Center(
          child:ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
          ),

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
                  onTap: () => isFirstSelected = true,
                  decoration: const InputDecoration(
                    labelText: "First number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // ================= SECOND INPUT =================
                TextFormField(
                  controller: bController,
                  keyboardType: TextInputType.number,
                  onTap: () => isFirstSelected = false,
                  decoration: const InputDecoration(
                    labelText: "Second number",
                    border: OutlineInputBorder(),
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
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.3,
                            ),
                            itemBuilder: (context, index) {
                              final value = buttons[index];

                              return CalcButton(
                                text: value,
                                onTap: () {

                                  if (value == "AC") {
                                    aController.clear();
                                    bController.clear();

                                    setState(() {
                                      selectedOperator = "";
                                      isFirstSelected = true;
                                    });
                                  }

                                  else if (["+", "-", "×", "÷", "%"].contains(value)) {
                                    setState(() {
                                      selectedOperator = value;
                                    });
                                  }

                                  else if (value == "=") {

                                    if (aController.text.isEmpty || bController.text.isEmpty) {
                                      return;
                                    }

                                    final a = double.parse(aController.text);
                                    final b = double.parse(bController.text);

                                    switch (selectedOperator) {
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
                                  }

                                  else {
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

                const SizedBox(height: 10),

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
