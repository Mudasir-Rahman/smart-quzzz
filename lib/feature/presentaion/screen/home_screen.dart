
import 'package:flutter/material.dart';
import 'package:quiez_assigenment/feature/presentaion/screen/web%20dashboard/analytics_screen.dart';

import 'mcqs_prectice_screen.dart';
import 'progress_screen.dart';
import 'dashboard_screen.dart';
import 'review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isDrawerOpen = false;

  final List<Widget> _screens = [
    const MCQPracticeScreen(),
    const ReviewScreen(),
    const ProgressScreen(),
    const DashboardScreen(),
    const AnalyticsScreen(),
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.quiz, 'label': 'Practice'},
    {'icon': Icons.repeat, 'label': 'Review'},
    {'icon': Icons.analytics, 'label': 'Progress'},
    {'icon': Icons.dashboard, 'label': 'Manage'},
    {'icon': Icons.bar_chart, 'label': 'Analytics'},
  ];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 768;

    if (isLargeScreen) {
      return _buildWebLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_menuItems[_currentIndex]['label'] as String),
        backgroundColor: _getAppBarColor(_currentIndex),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: _menuItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            label: item['label'] as String,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              _menuItems[_currentIndex]['icon'] as IconData,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              _menuItems[_currentIndex]['label'] as String,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: _getAppBarColor(_currentIndex),
        elevation: 2,
        actions: [
          // Optional: Add web-specific actions here
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: const Border(right: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo/Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.quiz, size: 32, color: Colors.blue),
                          const SizedBox(width: 12),
                          const Text(
                            'Smart MCQ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Practice & Analytics Dashboard',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Navigation Menu
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: _menuItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = index == _currentIndex;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Material(
                          color: isSelected ? Colors.blue[50] : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item['icon'] as IconData,
                                    color: isSelected ? Colors.blue : Colors.grey[700],
                                    size: 22,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item['label'] as String,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        color: isSelected ? Colors.blue : Colors.grey[800],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // User Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Student User',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Learning Progress: 75%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.grey[600]),
                        onPressed: () {
                          // Logout action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAppBarColor(int index) {
    switch (index) {
      case 0:
        return Colors.deepPurple; // Practice
      case 1:
        return Colors.blue; // Review
      case 2:
        return Colors.green; // Progress
      case 3:
        return Colors.orange; // Manage
      case 4:
        return Colors.teal; // Analytics
      default:
        return Colors.blue;
    }
  }
}