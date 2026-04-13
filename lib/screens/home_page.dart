import 'package:flutter/material.dart';
import '../widgets/home_option_card.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'placeholder_page.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          'DrowsiGuard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF636E72),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Rahul Sharma 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 10, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    'System Ready',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05,
                children: [
                  HomeOptionCard(
                    icon: Icons.camera_alt_rounded,
                    title: 'Start\nDetection',
                    color: const Color(0xFF6C5CE7),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PlaceholderPage(
                          title: 'Start Detection',
                        ),
                      ),
                    ),
                  ),
                  HomeOptionCard(
                    icon: Icons.history_rounded,
                    title: 'Drive\nHistory',
                    color: const Color(0xFF00B894),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PlaceholderPage(
                          title: 'Drive History',
                        ),
                      ),
                    ),
                  ),
                  HomeOptionCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Live\nAlerts',
                    color: const Color(0xFFFD79A8),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PlaceholderPage(
                          title: 'Live Alerts',
                        ),
                      ),
                    ),
                  ),
                  HomeOptionCard(
                    icon: Icons.person_rounded,
                    title: 'My\nProfile',
                    color: const Color(0xFF0984E3),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    ),
                  ),
                  HomeOptionCard(
                    icon: Icons.settings_rounded,
                    title: 'App\nSettings',
                    color: const Color(0xFFE17055),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsPage(),
                      ),
                    ),
                  ),
                  HomeOptionCard(
                    icon: Icons.help_outline_rounded,
                    title: 'Help &\nSupport',
                    color: const Color(0xFFA29BFE),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PlaceholderPage(
                          title: 'Help & Support',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}