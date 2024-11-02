import 'package:flutter/material.dart';

void main() {
  // an application to run
  runApp(MeasuresConverterApp());
}

// a widget that represents the application
class MeasuresConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Measures Converter',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: ConverterScreen(),
      ),
    );
  }
}

// a main widget that represents the screen
class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

// a state of the screen
class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _valueController = TextEditingController();
  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  double? _convertedValue;

  final List<String> _units = ['meters', 'feet', 'inches', 'centimeters'];

  // a method that converts a value from one unit to another and set the value state
  void _convert() {
    double? value = double.tryParse(_valueController.text);
    if (value == null) {
      setState(() {
        _convertedValue = null;
      });
      return;
    }

    double conversionFactor = _getConversionFactor(_fromUnit, _toUnit);
    setState(() {
      _convertedValue = value * conversionFactor;
    });
  }

  // a method that returns a conversion factor between two units
   double _getConversionFactor(String from, String to) {
    Map<String, double> conversionMap = {
      'meters_feet': 3.28084,
      'feet_meters': 0.3048,
      'meters_inches': 39.3701,
      'inches_meters': 0.0254,
      'meters_centimeters': 100.0,
      'centimeters_meters': 0.01,
      'feet_inches': 12.0,
      'inches_feet': 1 / 12.0,
      'feet_centimeters': 30.48,
      'centimeters_feet': 1 / 30.48,
      'inches_centimeters': 2.54,
      'centimeters_inches': 1 / 2.54,
    };
    
    String key = '${from}_$to';
    return conversionMap[key] ?? 1.0;
  }

  // a build method that returns the screen layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Value', style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
            ),
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter value to convert',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text('From', style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
            ),
            DropdownButton<String>(
              value: _fromUnit,
              onChanged: (String? newValue) {
              setState(() {
                _fromUnit = newValue!;
              });
              },
              items: _units.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
              }).toList(),
              isExpanded: true,
            ),
            SizedBox(height: 20),
            Center(
              child: Text('To', style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
            ),
            DropdownButton<String>(
              value: _toUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _toUnit = newValue!;
                });
              },
              items: _units.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert', style: TextStyle(fontSize: 20, color: Colors.blueAccent),),
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              ),
            ),
            SizedBox(height: 20),
            if (_convertedValue != null)
              Text(
                '${_valueController.text} $_fromUnit are ${_convertedValue!.toStringAsFixed(3)} $_toUnit',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
