import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/receipt_provider.dart';
import 'theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'screens/settings_screen.dart';
import 'screens/receipt_creation_screen.dart';
import 'screens/receipt_history_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()),
        ChangeNotifierProvider(create: (context) => ReceiptProvider()..loadReceipts()),
      ],
      child: const ReceiptGeneratorApp(),
    ),
  );
}

class ReceiptGeneratorApp extends StatelessWidget {
  const ReceiptGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Receipt Generator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const SplashScreen(),
        );
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();

  static _MainNavigationState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainNavigationState>();
  }
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    ReceiptCreationScreen(),
    ReceiptHistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Receipts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
