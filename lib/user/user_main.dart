import 'package:cognitive_app/user/Profile.dart';
import 'package:flutter/material.dart';
import 'package:cognitive_app/user/Dashboard.dart';

class UserMain extends StatefulWidget {
  final String baseUri;
  final String username;
  final List<int> scores;
  final String iqGroup; // Add iqGroup parameter

  UserMain({
    Key? key,
    required this.baseUri,
    this.username = 'Kamlesh',
    required this.scores,
    this.iqGroup = '90-105', // Add iqGroup parameter
  }) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Dashboard(
        baseUri: widget.baseUri,
        username: widget.username,
      ),
      ProfileScreen(
        username: widget.username,
        iqGroup: widget.iqGroup, // Pass iqGroup to ProfileScreen
      ), // Include the Profile widget
      // ChangePassword(), // Include the ChangePassword widget
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Change Password',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action for the floating action button
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Set your desired FAB color
      ),
    );
  }
}
