import 'package:flutter/material.dart';
import 'package:application_1/screens/achievements_list_screen.dart';
import 'package:application_1/screens/goals_list_screen.dart';
import 'package:application_1/screens/settings_screen.dart';
import 'package:application_1/screens/stats_screen.dart';
import 'package:application_1/screens/subjects_list_screen.dart';
import 'package:application_1/screens/dashboard_screen.dart';
import 'package:application_1/screens/heatmap_screen.dart';
import 'package:application_1/screens/insights_screen.dart';
import 'package:application_1/widgets/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SubjectsListScreen(),
    const GoalsListScreen(),
    const InsightsScreen(),
    const StatsScreen(),
    const HeatmapScreen(),
    const AchievementsListScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'Subjects',
    'Goals',
    'Insights',
    'Statistics',
    'Heatmap',
    'Achievements',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.deepPurpleAccent : Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: IndexedStack(
            key: ValueKey(_selectedIndex),
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isDark
              ? Colors.black.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.3),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_rounded, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.book_rounded, size: 26),
              label: 'Subjects',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.flag_rounded, size: 26),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insights_rounded, size: 26),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded, size: 26),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot, size: 26),
              label: 'Heatmap',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star_rounded, size: 26),
              label: 'Achievements',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_rounded, size: 26),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: isDark ? Colors.white70 : Colors.grey[600],
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
        ),
      ),
    );
  }
}
