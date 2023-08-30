import 'package:calculator/component.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: CalculatorNeuApp(),
    );
  }
}

const Color colorDark = Color(0xFF374352);
const Color colorLight = Color(0xFFe6eeff);

class CalculatorNeuApp extends StatefulWidget {
  @override
  _CalculatorNeuAppState createState() => _CalculatorNeuAppState();
}

class _CalculatorNeuAppState extends State<CalculatorNeuApp> {
  bool darkMode = false;
  String ans = '';
  String operation = '';
  double result = 0;
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 20.0,),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        darkMode = !darkMode;
                      });
                    },
                    child: _switchMode(),
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _calculate();
                        },
                        child: Text(
                          operation,
                          style: TextStyle(
                              fontSize: 35,
                              color: darkMode ? Colors.green : Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                       result.toString() ,
                      style: TextStyle(
                          fontSize:  55,
                          fontWeight: FontWeight.bold,
                          color: darkMode ? Colors.white : Colors.black54),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),

            Column(
              children: [
                _buttonsRow(['C', '(', ')', '/']),
                _buttonsRow(['sin', 'cos', 'tan', '%']),
                _buttonsRow(['7', '8', '9', 'x']),
                _buttonsRow(['4', '5', '6', '-']),
                _buttonsRow(['1', '2', '3', '+']),
                _buttonsRow(['0', '.', '⌫', '=']),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _calculate() {
    try {
      Parser p = Parser();
      ContextModel cm = ContextModel();

      String operationWithTrigFunctions = operation
          .replaceAllMapped(RegExp(r'sin(\d+)'), (Match match) {
        var x = match.group(1);
        double angle = double.tryParse(x ?? '0') ?? 0;
        return calculateSin(angle).toString();
      })
          .replaceAllMapped(RegExp(r'cos(\d+)'), (Match match) {
        var x = match.group(1);
        double angle = double.tryParse(x ?? '0') ?? 0;
        return calculateCos(angle).toString();
      })
          .replaceAllMapped(RegExp(r'tan(\d+)'), (Match match) {
        var x = match.group(1);
        double angle = double.tryParse(x ?? '0') ?? 0;
        return calculateTan(angle).toString();
      })
          .replaceAll('x', '*');

      Expression exp = p.parse(operationWithTrigFunctions);

      result = exp.evaluate(EvaluationType.REAL, cm);
      showResult = true;
      // print('Expression: $operation');
      // print('Evaluated Expression: $exp');
      // print('Result: $result');
    } catch (e) {
      print(e);
    }
  }



  double calculateSin(double degrees) {
    double radians = degrees * (pi / 180);
    return sin(radians);
  }
  double calculateCos(double degrees) {
    double radians = degrees * (pi / 180);
    return cos(radians);
  }

  double calculateTan(double degrees) {
    double radians = degrees * (pi / 180);
    return tan(radians);
  }


  Widget _buttonsRow(List<String> buttons) {
    return Row(
      children: buttons.map((buttonText) {
        return _buttonRounded(
          title: buttonText,
          onPressed: () =>_buttonClick(buttonText),

          textColor: buttonText == 'C' ? Colors.red : null,
          minWidth: buttonText.length > 1 ? 80.0 : null, // Adjust the minimum width for longer texts
        );
      }).toList(),
    );
  }


  void _buttonClick( button) {
    setState(() {
      if (button == '=') {
        _calculate();
      } else if (button == 'C') {
        operation = '';
        result = 0;
        showResult = false;
      } else if (button == '⌫') {
        if (operation.isNotEmpty) {
          operation = operation.substring(0, operation.length - 1);
        }
      } else {
        operation += button;
      }
    });
  }

  Widget _buttonRounded({
    String? title,
    double padding = 5,
    IconData? icon,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onPressed, double? minWidth,
  }) {
    return Expanded(
      child: DesignedContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(5),
        padding: EdgeInsets.all(padding),
        onPressed: onPressed,
        child: Container(
          width:  MediaQuery.of(context).size.width * 0.16,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Center(
            child: title != null
                ? Text(
              '$title',
              style: TextStyle(
                color: textColor ?? (darkMode ? Colors.white : Colors.black),
                fontSize: 30,
              ),
            )
                : Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return DesignedContainer(
      darkMode: darkMode,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      borderRadius: BorderRadius.circular(40),
      onPressed: () {
        setState(() {
          darkMode = !darkMode;
        });
      },
      child: Container(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.wb_sunny,
              color: darkMode ? Colors.grey : Colors.redAccent,
            ),
            Icon(
              Icons.nightlight_round,
              color: darkMode ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
