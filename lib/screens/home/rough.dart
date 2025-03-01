import 'package:flutter/material.dart';
import 'package:zesty/screens/home/home.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with WidgetsBindingObserver {
  List<String> data = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer for lifecycle events
    fetchData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
    print("dispose");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when the screen is revisited
      print("back press");
      fetchData();
    }
  }


  void fetchData() async {
    // Fetch data from Hive
    // Example: data = await Hive.box('myBox').get('data');
    setState(() {
      data = ['Item 1', 'Item 2', 'Item 3']; // Example data
    });
  }



  void _navigateToSecondScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(address: "address", subAddress: "subAddress"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSecondScreen,
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Modify data in Hive
            // Example: Hive.box('myBox').put('data', ['Modified Item 1', 'Modified Item 2']);

            Navigator.pop(context); // Return to the first screen
          },
          child: Text('Modify Data and Go Back'),
        ),
      ),
    );
  }
}