
import 'dart:ffi';
import 'dart:math';

import 'package:calculator/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator App",
      home: CalculatorApp(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({ Key? key }) : super(key: key);

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State <CalculatorApp> {
  late TextEditingController _controller;
  String _expression = '';
  String _result = '';
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _expression = '';
        _result = '';
        _controller.clear();
      } else if (buttonText == "⌫") {
        _expression = _expression.substring(0, _expression.length - 1);
      } else if (buttonText == "=") {
        _evaluateExpression();
      } else {
        _expression += buttonText;
        _controller.text = _expression;
      }
    });
  }

  void _evaluateExpression() {
    try {
      var userInput = _expression;
      userInput = _expression.replaceAll("x", "*").replaceAll("÷", "/").replaceAll(",", ".");
      Parser p = Parser();
      Expression expression = p.parse(userInput);
      ContextModel cm = ContextModel();
      var finalValue = expression.evaluate(EvaluationType.REAL, cm);
      _result = finalValue.toString();
    } catch (e) {
      _result = 'Error';
    }
  }

  void _toggleDarkMode() {
    setState(() {
      darkMode = !darkMode;
      _saveDarkModeToPrefs();
    });
  }

  void _saveDarkModeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? darkModeFromPrefs = prefs.getBool('darkMode');
    if (darkModeFromPrefs == null) {
      prefs.setBool('darkMode', false);
    } else {
      prefs.setBool('darkMode', darkMode);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.black12 : Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: darkMode ? Colors.purple.withOpacity(0.5) : Colors.purple.withOpacity(0.5),
        title: Text(
          '21_M Daffa Teuku F A',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28.0,
            fontWeight: FontWeight.w400,
            color: darkMode ? Colors.white.withOpacity(0.75) : Colors.black.withOpacity(0.75),
          ),
        ),

        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(darkMode ? Icons.light_mode : Icons.dark_mode, size: 30, color: darkMode ? Colors.white : Colors.black,),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.black12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_expression.isEmpty ? '0' : _expression, style: GoogleFonts.plusJakartaSans(
                  fontSize: 48,
                  color: darkMode ? Colors.white : Colors.black,
                )),
                SizedBox(
                  height: 40,
                ),
                Text(_result.isEmpty ? '0' : _result, style: GoogleFonts.plusJakartaSans(
                  fontSize: 48,
                  color: Colors.purple.shade800,
                )),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )),
          Row(
            children: [
              button(text: "AC", tColor: Colors.purple, buttonBgColor: Colors.white10),
              button(text: "⌫", tColor: Colors.purple, buttonBgColor: Colors.white10),
              button(text: "%", tColor: Colors.purple, buttonBgColor: Colors.white10),
              button(text: "÷", tColor: Colors.purple, buttonBgColor: Colors.white10),
            ],
          ),
          Row(
            children: [
              button(text: "1", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "2", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "3", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "x", tColor: Colors.purple, buttonBgColor: Colors.white10),
            ],
          ),
          Row(
            children: [
              button(text: "4", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "5", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "6", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "-", tColor: Colors.purple, buttonBgColor: Colors.white10),
            ],
          ),
          Row(
            children: [
              button(text: "7", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "8", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "9", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "+", tColor: Colors.purple, buttonBgColor: Colors.white10),
            ],
          ),
          Row(
            children: [
              button(text: "00", tColor: Colors.purple, buttonBgColor: Colors.white10),
              button(text: "0", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: ",", tColor: darkMode ? Colors.black : Colors.white, buttonBgColor: darkMode ? Colors.white70 : Colors.black),
              button(text: "=", buttonBgColor: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget button({
    required String text, tColor = Colors.white, buttonBgColor = buttonColor, double? fontSize
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),

              padding: EdgeInsets.all(22),
              primary: buttonBgColor,
            ),
            onPressed: () {
              _onButtonPressed(text);
            },
            child: Text(
            "${text}",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.normal,
              color: tColor,
              fontSize: fontSize ?? 25,
            )
        ),
      ),
    ),);
  }
}