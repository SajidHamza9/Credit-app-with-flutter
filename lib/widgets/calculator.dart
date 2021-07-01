import 'package:flutter/material.dart';
import 'buttons.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatelessWidget {
  final h;
  final w;
  final Function updateMontant;
  final Function updateOperation;
  String operation;

  Calculator(
      {required this.h,
      required this.w,
      required this.operation,
      required this.updateMontant,
      required this.updateOperation});

// Array of button
  final List<String> buttons = [
    'C',
    '+/-',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: buttons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: w / h, crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) => LayoutBuilder(
              builder: (context, constraints) {
                if (index == 0) {
                  return MyButton(
                    buttontapped: () {
                      updateOperation('');
                      updateMontant(0.0);
                    },
                    buttonText: buttons[index],
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  );
                }

                // +/- button
                else if (index == 1) {
                  return MyButton(
                    buttonText: buttons[index],
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  );
                }
                // % Button
                else if (index == 2) {
                  return MyButton(
                    buttontapped: () {
                      final last = operation.isNotEmpty
                          ? operation[operation.length - 1]
                          : operation;
                      if ((isOperator(last) && isOperator(buttons[index])) ||
                          (isOperator(buttons[index]) && operation.isEmpty)) {
                        return;
                      }
                      updateOperation(operation + buttons[index]);
                    },
                    buttonText: buttons[index],
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  );
                }
                // Delete Button
                else if (index == 3) {
                  return MyButton(
                    buttontapped: () {
                      if (operation.isNotEmpty) {
                        updateOperation(
                            operation.substring(0, operation.length - 1));
                      }
                    },
                    buttonText: buttons[index],
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  );
                }
                // Equal_to Button
                else if (index == 18) {
                  return MyButton(
                    buttontapped: () {
                      equalPressed();
                    },
                    buttonText: buttons[index],
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  );
                }

                // other buttons
                else {
                  return MyButton(
                    buttontapped: () {
                      final last = operation.isNotEmpty
                          ? operation[operation.length - 1]
                          : operation;
                      if ((isOperator(last) && isOperator(buttons[index])) ||
                          (isOperator(buttons[index]) && operation.isEmpty)) {
                        return;
                      }
                      updateOperation(operation + buttons[index]);
                    },
                    buttonText: buttons[index],
                    color: isOperator(buttons[index])
                        ? Theme.of(context).accentColor
                        : Colors.white,
                    textColor: isOperator(buttons[index])
                        ? Colors.white
                        : Colors.black,
                  );
                }
              },
            )
        // Clear Button
        ); // GridView.builder
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=' || x == '%') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = operation;
    finaluserinput = operation.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    updateMontant(eval);
  }
}
