import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/calculator_view_model.dart';

class HistoryBottomSheet extends StatelessWidget {
  const HistoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorViewModel>(
      builder: (context, vm, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .7,
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
                  icon: const Icon(Icons.delete_forever,
                      color:Colors.blueGrey),
                  label: const Text("Delete All"),
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
                        icon: const Icon(Icons.delete),
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
  }
}