//
// import 'package:flutter/material.dart';
// import 'package:quiez_assigenment/feature/presentaion/screen/web%20dashboard/analytics_screen.dart';
//
// import 'mcqs_prectice_screen.dart';
// import 'progress_screen.dart';
// import 'dashboard_screen.dart';
// import 'review_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;
//   bool _isDrawerOpen = false;
//
//   final List<Widget> _screens = [
//     const MCQPracticeScreen(),
//     const ReviewScreen(),
//     const ProgressScreen(),
//     const DashboardScreen(),
//     const AnalyticsScreen(),
//   ];
//
//   final List<Map<String, dynamic>> _menuItems = [
//     {'icon': Icons.quiz, 'label': 'Practice'},
//     {'icon': Icons.repeat, 'label': 'Review'},
//     {'icon': Icons.analytics, 'label': 'Progress'},
//     {'icon': Icons.dashboard, 'label': 'Manage'},
//     {'icon': Icons.bar_chart, 'label': 'Analytics'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final isLargeScreen = MediaQuery.of(context).size.width > 768;
//
//     if (isLargeScreen) {
//       return _buildWebLayout();
//     } else {
//       return _buildMobileLayout();
//     }
//   }
//
//   Widget _buildMobileLayout() {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_menuItems[_currentIndex]['label'] as String),
//         backgroundColor: _getAppBarColor(_currentIndex),
//         centerTitle: true,
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Theme.of(context).primaryColor,
//         unselectedItemColor: Colors.grey,
//         items: _menuItems.map((item) {
//           return BottomNavigationBarItem(
//             icon: Icon(item['icon'] as IconData),
//             label: item['label'] as String,
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildWebLayout() {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Icon(
//               _menuItems[_currentIndex]['icon'] as IconData,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               _menuItems[_currentIndex]['label'] as String,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//         backgroundColor: _getAppBarColor(_currentIndex),
//         elevation: 2,
//         actions: [
//           // Optional: Add web-specific actions here
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.white),
//             onPressed: () {
//               // Settings action
//             },
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           // Sidebar Navigation
//           Container(
//             width: 280,
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               border: const Border(right: BorderSide(color: Colors.grey, width: 1)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // App Logo/Header
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(Icons.quiz, size: 32, color: Colors.blue),
//                           const SizedBox(width: 12),
//                           const Text(
//                             'Smart MCQ',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Practice & Analytics Dashboard',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(height: 1),
//
//                 // Navigation Menu
//                 Expanded(
//                   child: ListView(
//                     padding: const EdgeInsets.all(8),
//                     children: _menuItems.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final item = entry.value;
//                       final isSelected = index == _currentIndex;
//
//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         child: Material(
//                           color: isSelected ? Colors.blue[50] : Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _currentIndex = index;
//                               });
//                             },
//                             borderRadius: BorderRadius.circular(8),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     item['icon'] as IconData,
//                                     color: isSelected ? Colors.blue : Colors.grey[700],
//                                     size: 22,
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Text(
//                                       item['label'] as String,
//                                       style: TextStyle(
//                                         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                                         color: isSelected ? Colors.blue : Colors.grey[800],
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                   if (isSelected)
//                                     Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 // User Profile Section
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border(top: BorderSide(color: Colors.grey[300]!)),
//                   ),
//                   child: Row(
//                     children: [
//                       const CircleAvatar(
//                         backgroundColor: Colors.blue,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Student User',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             Text(
//                               'Learning Progress: 75%',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.logout, color: Colors.grey[600]),
//                         onPressed: () {
//                           // Logout action
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Main Content Area
//           Expanded(
//             child: Container(
//               color: Colors.grey[100],
//               child: _screens[_currentIndex],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getAppBarColor(int index) {
//     switch (index) {
//       case 0:
//         return Colors.deepPurple; // Practice
//       case 1:
//         return Colors.blue; // Review
//       case 2:
//         return Colors.green; // Progress
//       case 3:
//         return Colors.orange; // Manage
//       case 4:
//         return Colors.teal; // Analytics
//       default:
//         return Colors.blue;
//     }
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/presentaion/bloc/auth_bloc.dart';
import '../../auth/presentaion/bloc/auth_event.dart';
import '../../auth/presentaion/bloc/auth_state.dart';

import 'mcqs_prectice_screen.dart';
import 'progress_screen.dart';
import 'dashboard_screen.dart';
import 'review_screen.dart';
import 'web dashboard/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _userId;
  String? _userName;
  bool _isInitialized = false;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.quiz, 'label': 'Practice'},
    {'icon': Icons.repeat, 'label': 'Review'},
    {'icon': Icons.analytics, 'label': 'Progress'},
    {'icon': Icons.dashboard, 'label': 'Manage'},
    {'icon': Icons.bar_chart, 'label': 'Analytics'},
  ];

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeUser(context));
  }

  void _initializeUser(BuildContext context) {
    if (_isInitialized) return;
    _isInitialized = true;

    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;

    if (state is AuthSuccess) {
      _setupScreens(state.user.id, state.user.fullName);
    } else {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final userName = user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            user.email?.split('@').first ??
            'User';
        _setupScreens(user.id, userName.toString());
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setupScreens(String userId, String? userName) {
    setState(() {
      _userId = userId;
      _userName = userName ?? 'User';
      _screens = [
        MCQPracticeScreen(userId: userId),
        ReviewScreen(userId: userId),
        ProgressScreen(),
        DashboardScreen(userId: userId),
        AnalyticsScreen(userId: userId),
      ];
      _isLoading = false;
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _userName ?? 'User',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              _userId != null ? 'ID: ${_userId!.substring(0, 8)}...' : '',
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _userName != null && _userName!.isNotEmpty
                    ? _userName![0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
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
                      color: isSelected ? Colors.blue : Colors.grey[700]),
                  title: Text(item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.grey[800],
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
    );
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
              child: const Text('Cancel')
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
      case 0:
        return Colors.deepPurple;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading Home...'),
            ],
          ),
        ),
      );
    }

    final isLargeScreen = MediaQuery.of(context).size.width > 768;
    final appBarColor = _getAppBarColor(_currentIndex);

    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthLoggedOut || state is AuthFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/signin');
          });
        }
      },
      child: Scaffold(
        drawer: isLargeScreen ? null : _buildDrawer(),
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: isLargeScreen
            ? null
            : BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: _menuItems
              .map((item) => BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            label: item['label'] as String,
          ))
              .toList(),
        ),
      ),
    );
  }
}