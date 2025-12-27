import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiez_assigenment/feature/auth/domain/entity/auth_entity.dart';

import '../../auth/presentaion/bloc/auth_bloc.dart';
import '../../auth/presentaion/bloc/auth_event.dart';
import 'mcqs_prectice_screen.dart';
import 'progress_screen.dart';
import 'dashboard_screen.dart';
import 'review_screen.dart';
import 'web dashboard/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserEntity user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _screens;
  late final List<Map<String, dynamic>> _menuItems;

  @override
  void initState() {
    super.initState();
    _screens = [
      MCQPracticeScreen(userId: widget.user.id),
      ReviewScreen(userId: widget.user.id),
      ProgressScreen(),
      DashboardScreen(userId: widget.user.id),
      AnalyticsScreen(userId: widget.user.id),
    ];

    _menuItems = [
      {'icon': Icons.quiz, 'label': 'Practice'},
      {'icon': Icons.repeat, 'label': 'Review'},
      {'icon': Icons.analytics, 'label': 'Progress'},
      {'icon': Icons.dashboard, 'label': 'Manage'},
      {'icon': Icons.bar_chart, 'label': 'Analytics'},
    ];
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<AuthBloc>().add(SignOutEvent());
    }
  }

  Color _getAppBarColor(int index) {
    switch (index) {
      case 0: return Colors.deepPurple;
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.orange;
      case 4: return Colors.teal;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 768;
    return isLargeScreen ? _buildWebLayout() : _buildMobileLayout();
  }

  Widget _buildWebLayout() {
    return Row(
        children: [
        Container(
        width: 280,
        color: Colors.grey[50],
        child: Column(
        children: [
        Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
        Colors.deepPurple.shade700,
        Colors.deepPurple.shade500,
        ],
        ),
        ),
        child: Row(
        children: [
        CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
        widget.user.fullName.isNotEmpty ? widget.user.fullName[0].toUpperCase() : 'U',
        style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
        ),
        ),
        ),
        const SizedBox(width: 12),
        Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
        widget.user.fullName,
        style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        ),
        ),
        Text(
        'ID: ${widget.user.id.substring(0, 8)}...',
        style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.8),
        ),
        ),
        ],
        ),
        ),
        ],
        ),
        ),
        const SizedBox(height: 20),
        Expanded(
        child: ListView(
        children: _menuItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == _currentIndex;
                    return ListTile(
                      selected: isSelected,
                      leading: Icon(item['icon'] as IconData,
                          color: isSelected ? Colors.deepPurple : Colors.grey[700]),
                      title: Text(item['label'] as String,
                          style: TextStyle(
                            color: isSelected ? Colors.deepPurple : Colors.grey[800],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          )),
                      onTap: () => setState(() => _currentIndex = index),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _menuItems[_currentIndex]['icon'] as IconData,
                      color: _getAppBarColor(_currentIndex),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _menuItems[_currentIndex]['label'] as String,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _getAppBarColor(_currentIndex),
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        widget.user.fullName.isNotEmpty ? widget.user.fullName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _screens[_currentIndex]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_menuItems[_currentIndex]['icon'] as IconData, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              _menuItems[_currentIndex]['label'] as String,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: _getAppBarColor(_currentIndex),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Text(
                widget.user.fullName.isNotEmpty ? widget.user.fullName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getAppBarColor(_currentIndex),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.user.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                'ID: ${widget.user.id.substring(0, 8)}...',
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.user.fullName.isNotEmpty ? widget.user.fullName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade700,
                    Colors.deepPurple.shade500,
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _menuItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == _currentIndex;
                  return ListTile(
                    selected: isSelected,
                    leading: Icon(item['icon'] as IconData,
                        color: isSelected ? Colors.deepPurple : Colors.grey[700]),
                    title: Text(item['label'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.deepPurple : Colors.grey[800],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                    onTap: () {
                      setState(() => _currentIndex = index);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        items: _menuItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item['icon'] as IconData),
                  label: item['label'] as String,
                ))
            .toList(),
      ),
    );
  }
}
