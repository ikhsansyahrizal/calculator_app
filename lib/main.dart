import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Calculator',
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output = "0";
  double _num1 = 0;
  String _operand = "";
  bool _shouldResetOutput = true;

  void _handleButtonPress(String buttonText) {
    setState(() {
      switch (buttonText) {
        case "C":
          _resetCalculator();
          break;
        case "+/-":
          _toggleSign();
          break;
        case "%":
          _calculatePercentage();
          break;
        case ".":
          _addDecimalPoint();
          break;
        case "=":
          _calculateResult();
          break;
        case "⌫": // Backspace
          _handleBackspace();
          break;
        case "+":
        case "-":
        case "×":
        case "÷":
          _setOperation(buttonText);
          break;
        default:
          _appendDigit(buttonText);
      }
    });
  }

  void _resetCalculator() {
    _output = "0";
    _num1 = 0;
    _operand = "";
    _shouldResetOutput = true;
  }

  void _toggleSign() {
    if (_output != "0") {
      _output = (_output.startsWith("-") ? _output.substring(1) : "-$_output");
    }
  }

  void _calculatePercentage() {
    double number = double.parse(_output);
    _output = (number / 100).toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  void _addDecimalPoint() {
    if (!_output.contains(".")) {
      _output += ".";
    }
  }

  void _handleBackspace() {
    if (_output.length > 1) {
      _output = _output.substring(0, _output.length - 1);
    } else {
      _output = "0";
    }
  }

  void _setOperation(String op) {
    _num1 = double.parse(_output);
    _operand = op;
    _shouldResetOutput = true;
  }

  void _appendDigit(String digit) {
    if (_shouldResetOutput) {
      _output = digit;
      _shouldResetOutput = false;
    } else {
      _output = _output == "0" ? digit : _output + digit;
    }
  }

  void _calculateResult() {
    if (_operand.isEmpty) return;

    double num2 = double.parse(_output);
    double result;

    switch (_operand) {
      case "+":
        result = _num1 + num2;
        break;
      case "-":
        result = _num1 - num2;
        break;
      case "×":
        result = _num1 * num2;
        break;
      case "÷":
        result = _num1 / num2;
        break;
      default:
        return;
    }

    _output = result.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
    _operand = "";
    _shouldResetOutput = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildDisplay(),
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return Expanded(
      child: Container(
        color: Colors.grey[850],
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _output,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return GridView.count(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      crossAxisCount: 4,
      children: [
        _buildButton("C", color: Colors.red[400]),
        _buildButton("⌫", color: Colors.red[400]),
        _buildButton("%", color: Colors.blue[400]),
        _buildOperationButton("÷"),
        _buildButton("7"), _buildButton("8"), _buildButton("9"),
        _buildOperationButton("×"),
        _buildButton("4"), _buildButton("5"), _buildButton("6"),
        _buildOperationButton("-"),
        _buildButton("1"), _buildButton("2"), _buildButton("3"),
        _buildOperationButton("+"),
        _buildButton("+/-"), _buildButton("0"), _buildButton("."),
        _buildButton("=", color: Colors.green[400]),
      ],
    );
  }

  Widget _buildButton(String text, {Color? color}) {
    return CalculatorButton(
      text: text,
      backgroundColor: color ?? Theme.of(context).canvasColor,
      foregroundColor: color != null ? Colors.white : Theme.of(context).primaryColorDark,
      onTap: () => _handleButtonPress(text),
    );
  }

  Widget _buildOperationButton(String text) {
    return CalculatorButton(
      text: text,
      backgroundColor: Theme.of(context).primaryColorDark,
      foregroundColor: Theme.of(context).primaryColorLight,
      onTap: () => _handleButtonPress(text),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final VoidCallback onTap;

  const CalculatorButton({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}