import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oneadmin/firebase_options.dart';
import 'package:oneadmin/pages/HomePage.dart';
import 'package:oneadmin/pages/LibraryPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web App with Navigation',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          background: const Color.fromARGB(255, 241, 236, 236),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track selected navigation index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(), // Replace with your Home page widget
      const LibraryPage(), // Replace with your Library page widget
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double drawerWidth = 200.0; // Adjust drawer width as needed
        bool isSmallScreen = constraints.maxWidth < 600; // Adjust breakpoint
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(32, 147, 147, 147),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('O n e A d m i n'),
                const Spacer(),

                SizedBox(
                  width: 200.0,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: 'Search...',
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                // if (isSmallScreen)
                //   IconButton(
                //     icon: const Icon(Icons.menu),
                //     onPressed: () => Scaffold.of(context).openDrawer(),
                //   ),
              ],
            ),
          ),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // const DrawerHeader(
                //   decoration: BoxDecoration(
                //     color: Colors.blue,
                //   ),
                //   child: Text(
                //     '',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 24,
                //     ),
                //   ),
                // ),
                ListTile(
                  title: const Text('Home'),
                  selected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                ListTile(
                  title: const Text('Library'),
                  selected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
              ],
            ),
          ),
          body: Row(
            // Use Row for responsive layout
            children: [
              if (!isSmallScreen) // Only show drawer on larger screens
                SizedBox(
                  width: drawerWidth,
                  child: Drawer(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // const DrawerHeader(
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue,
                        //   ),
                        //   child: Text(
                        //     '',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 24,
                        //     ),
                        //   ),
                        // ),
                        ListTile(
                          title: const Text('Home'),
                          selected: _selectedIndex == 0,
                          onTap: () => _onItemTapped(0),
                        ),
                        ListTile(
                          title: const Text('Library'),
                          selected: _selectedIndex == 1,
                          onTap: () => _onItemTapped(1),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: pages[_selectedIndex],
              ),
            ],
          ),
          // body: pages[_selectedIndex], // Display selected page content
        );
      },
    );
  }
}
