import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Budget Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String sheetId = "1Ei6g2bqXfw85vIMfvmMYyVgbIQBhn42whIu7birIwYo";
  final String apiKey = "AIzaSyBQLrhJVB6SPOieR1eL62EKmdQvd0XQFik";
  /*
   How to get API Key:
   Go to console.cloud.google.com
   */

  List<List<dynamic>> _data = [];

  Future<void> _fetchSheetData() async {
    final response = await http.get(
      Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Categories and Percentages?key=$apiKey'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _data = (data['values'] as List).cast<List<dynamic>>();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _fetchSheetData,
              child: Text('Fetch Sheet Data'),
            ),
            SizedBox(height: 20),
            if (_data.isNotEmpty)
              Column(
                children: _data.map((row) {
                  return Text(row.join(', '));
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}