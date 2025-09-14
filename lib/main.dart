import 'package:e6b_flutter/calculatorLists/ConversionsList.dart';
import 'package:e6b_flutter/calculatorLists/FavoritesList.dart';
import 'package:e6b_flutter/calculatorLists/FunctionsList.dart';
import 'package:e6b_flutter/components/Calculators.dart';
import 'package:e6b_flutter/pages/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(const E6BApp());
}

class E6BApp extends StatelessWidget {
  const E6BApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
      home: const HomePage(),
    );
  }
}

// Determine the width of the display to display either phone or tablet layout
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return const PhoneHomePage();
    } else {
      return const TabletHomePage();
    }
  }
}

class PhoneHomePage extends StatefulWidget {
  const PhoneHomePage({super.key});

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {
  int _selectedIndex = 0;

  final _pages = const [
    FavoritesList(),
    FunctionsList(),
    ConversionsList(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E6B TABLET LAYOUT"),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.functions),
              label: "Functions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: "Conversions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ]),
    );
  }
}

class TabletHomePage extends StatefulWidget {
  const TabletHomePage({super.key});

  @override
  State<TabletHomePage> createState() => _TabletHomePageState();
}

class _TabletHomePageState extends State<TabletHomePage> {
  int _selectedIndex = 0;
  int? _selectedCalculatorIndex;

  final _pages = const [
    FavoritesList(),
    FunctionsList(),
    ConversionsList(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E6B TABLET LAYOUT"),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 350,
            child: _pages[_selectedIndex],
          ),
          const VerticalDivider(width: 1),
          Expanded(
              child: _selectedCalculatorIndex == null
                  ? calculators[0]
                  : const Center(child: Text("calculator selected"))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.functions),
              label: "Functions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: "Conversions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ]),
    );
  }
}
