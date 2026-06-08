import 'package:flutter/material.dart';

import '../viewmodel/calculator_model.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key,
  required this.viewModel,
  });

  final CalculatorViewModel viewModel;

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {

  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final viewModel = widget.viewModel;

    return Scaffold(
      appBar : AppBar(
        title : const Text("Calculator App"),

      ),
      body : SafeArea(
        child: ListenableBuilder(
          listenable:viewModel,
          builder: (context,_){
            return Padding(
        padding : const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            TextField(
              controller : aController,
              keyboardType:TextInputType.number,
              decoration:const InputDecoration(
                labelText:"First number",
              ),
            ),

            const SizedBox(height:10),

            TextField(
              controller: bController,
              keyboardType:TextInputType.number,
              decoration: const InputDecoration(
                labelText:"Second number",
              ),
            ),

            const SizedBox(height:20),

            Wrap (
              spacing: 10,
              runSpacing:10,
              children: [

                ElevatedButton(
                  onPressed: (){
                    viewModel.add(
                    double.parse(aController.text),
                    double.parse(bController.text),
                    );
                 },
                  child: const Text("+"),
                ),

                ElevatedButton(
                  onPressed:(){
                    viewModel.subtract(
                      double.parse(aController.text),
                      double.parse(bController.text),
                    );
                  },
                  child: const Text("- "),
                ),


                ElevatedButton (
                  onPressed:(){
                    viewModel.multiply(
                      double.parse(aController.text),
                      double.parse(bController.text),
                    );
                  },
                  child: const Text ("*"),
                ),


                ElevatedButton (
                  onPressed: (){
                    viewModel.divide(
                      double.parse(aController.text),
                      double.parse(bController.text),
                    );
                  },
                  child: const Text("/"),
                ),


              ],
            ),
            const SizedBox(height:30),

            Container(
              padding : const EdgeInsets.all(20),
              decoration:BoxDecoration(
                color:Colors.grey.shade200,
                borderRadius:BorderRadius.circular(10),
              ),

            child:Text(
              "Result : ${viewModel.result}",
              style : const TextStyle(
                fontSize:24,
                fontWeight: FontWeight.bold,
                    ),
                  ),
                 ),
               ],
              ),
             );
            },
        ),
      ),
    );
  }
}
