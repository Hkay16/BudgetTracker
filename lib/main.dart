import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/sheets/v4.dart' as sheets;
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
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPurchasePage()),
                );
              },
              child: Text('Add Purchase'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewEntriesPage()),
                );
              },
              child: Text('View Entries'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewCurrentPeriodPage()),
                );
              },
              child: Text('View Current Period'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetBudgetsPage()),
                );
              },
              child: Text('Set Budgets'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPurchasePage extends StatefulWidget {
  @override
  _AddPurchasePageState createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    categoryController.dispose();
    priceController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> addPurchaseToSheet() async {
    final spreadsheetId = '1Ei6g2bqXfw85vIMfvmMYyVgbIQBhn42whIu7birIwYo';
    final apiKey = 'AIzaSyBQLrhJVB6SPOieR1eL62EKmdQvd0XQFik';
    final sheetName = 'Item Entries Data';

    final url = Uri.parse(
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName?key=$apiKey');

    final headers = {
      'Content-Type': 'application/json',
    };

    final rowData = {
      'Date': dateController.text,
      'Category': categoryController.text,
      'Price': priceController.text,
      'Name': nameController.text,
      'Description': descriptionController.text,
    };

    final body = json.encode({
      'values': [rowData.values.toList()],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        showSnackbar('Purchase added successfully');
      } else {
        showSnackbar('Error adding purchase');
      }
    } catch (e) {
      showSnackbar('Exception while adding purchase');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Purchase'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date (MM/DD/YYYY)',
                    ),
                  ),
                ),
                TableCell(
                  child: TextFormField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                ),
                TableCell(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ),
                // Add an empty TableCell for alignment
                TableCell(
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addPurchaseToSheet();
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class ViewEntriesPage extends StatefulWidget {
  @override
  _ViewEntriesPageState createState() => _ViewEntriesPageState();
}

class _ViewEntriesPageState extends State<ViewEntriesPage> {
  // Define your state variables for filtering and displaying entries

  List<Entry> entries = []; // Replace with actual list of entries

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Entries'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Add filter options here (e.g., dropdowns for date, category)

            SizedBox(height: 16),

            Table(
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              border: TableBorder.all(),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  children: [
                    TableCell(child: Text('Date')),
                    TableCell(child: Text('Category')),
                    TableCell(child: Text('Price')),
                    TableCell(child: Text('Actions')),
                  ],
                ),
                ...entries.map((entry) {
                  return TableRow(
                    children: [
                      TableCell(child: Text(entry.date)),
                      TableCell(child: Text(entry.category)),
                      TableCell(child: Text(entry.price.toString())),
                      TableCell(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Implement edit functionality
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                // Implement delete functionality
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Entry {
  final String date;
  final String category;
  final double price;

  Entry({required this.date, required this.category, required this.price});
}

class ViewCurrentPeriodPage extends StatefulWidget {
  @override
  _ViewCurrentPeriodPageState createState() => _ViewCurrentPeriodPageState();
}

class _ViewCurrentPeriodPageState extends State<ViewCurrentPeriodPage> {
  // Define your state variables for displaying current period data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Current Period'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Display current period data here
          ],
        ),
      ),
    );
  }
}

class SetBudgetsPage extends StatefulWidget {
  @override
  _SetBudgetsPageState createState() => _SetBudgetsPageState();
}

class _SetBudgetsPageState extends State<SetBudgetsPage> {
  int numberOfCategories = 0;

  @override
  void initState() {
    super.initState();
    fetchCategoriesCount();
  }

  Future<void> fetchCategoriesCount() async {
    final sheetsApi = sheets.SheetsApi(http.Client());

    final spreadsheetId = '1Ei6g2bqXfw85vIMfvmMYyVgbIQBhn42whIu7birIwYo';
    final sheetRange = 'Categories and Percentages!A1:H1';
    final apiKey = 'AIzaSyBQLrhJVB6SPOieR1eL62EKmdQvd0XQFik';

    final response = await http.get(
      Uri.parse(
          'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetRange?key=$apiKey'),
    );

    try {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final firstRow = responseData['values']?.first as List<dynamic>?;
      if (firstRow != null) {
        numberOfCategories =
            firstRow.where((cell) => cell != null && cell.isNotEmpty).length;
        setState(() {});
      }
    } catch (e) {
      print('Error fetching categories count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Budgets'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: List.generate(
            numberOfCategories,
            (index) => TableRow(
              children: [
                TableCell(
                  child: Text(
                    'Category ${index + 1}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: TextFormField(
                      // Create TextFormField for budget input
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement update logic here
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
