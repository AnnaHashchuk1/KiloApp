import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart'; 
import 'stats_screen.dart';
import 'add_activity_screen.dart';
import 'log_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart'; 
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navBarIndex = 0; 

  late final List<Widget> _widgetOptions;
  
  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
        FeedScreen(userName: widget.userName),
        const StatsScreen(),
        const AddActivityScreen(),
        const LogScreen(),
        const ProfileScreen(),
      ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _navBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor, 
      body: _widgetOptions.elementAt(_navBarIndex), 
      
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _navBarIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class Activity {
  final String title;
  final String details;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;

  Activity({
    required this.title,
    required this.details,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
  });
}

final List<Activity> recentActivities = [
  Activity(title: 'Leg Day', details: '45 minutes • 300 kcal', timeAgo: '2h ago', icon: Icons.fitness_center, iconColor: kSecondaryColor),
  Activity(title: 'Morning Run', details: '2.5 miles • 28 minutes', timeAgo: 'Yesterday', icon: Icons.directions_run, iconColor: kSecondaryColor),
  Activity(title: 'HIIT Cardio', details: '20 minutes • 250 kcal', timeAgo: 'Tuesday', icon: Icons.favorite, iconColor: kSecondaryColor),
  Activity(title: 'Evening Cycle', details: '10 miles • 45 minutes', timeAgo: 'Wednesday', icon: Icons.directions_bike, iconColor: kSecondaryColor),
  Activity(title: 'Yoga Session', details: '60 minutes • 150 kcal', timeAgo: 'Wednesday', icon: Icons.self_improvement, iconColor: kSecondaryColor),
  Activity(title: 'Full Body Circuit', details: '50 minutes • 420 kcal', timeAgo: 'Last Week', icon: Icons.fitness_center, iconColor: kSecondaryColor),
  Activity(title: 'Long Walk', details: '5 miles • 90 minutes', timeAgo: 'Last Week', icon: Icons.directions_walk, iconColor: kSecondaryColor),
];

class FeedScreen extends StatelessWidget {
  final String userName;
  const FeedScreen({super.key, required this.userName});

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kInputFillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: kSecondaryColor.withAlpha(178), size: 24),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: kTextColor, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgressCard() {
    const double progress = 0.65;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kInputFillColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Goal Progress',
                style: TextStyle(color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(color: kSecondaryColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: kPrimaryColor,
            valueColor: const AlwaysStoppedAnimation<Color>(kSecondaryColor),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('3/5 Workouts', style: TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('Completed', style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 14)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Next: ', 
                        style: TextStyle(
                          color: kTextColor, 
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Shoulders & Arms', 
                        style: TextStyle(
                          color: kTextColor.withAlpha(178), 
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: kInputFillColor, 
          expandedHeight: 80, 
          toolbarHeight: 0, 
          forceElevated: true, 
          elevation: 0, 
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), 
              child: Align( 
                alignment: Alignment.bottomCenter, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end, 
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end, 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back,', style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 16, fontWeight: FontWeight.normal)),
                          Text(userName, style: const TextStyle(color: kTextColor, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: kTextColor.withAlpha(178), size: 28), 
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatCard(title: 'Calories', value: '850', subtitle: 'of 1200 kcal', icon: Icons.local_fire_department),
                        const SizedBox(width: 16),
                        _buildStatCard(title: 'Time Logged', value: '1h 45m', subtitle: "Today's total", icon: Icons.access_time_filled),
                      ],
                    ),

                    _buildGoalProgressCard(),

                    // --- ТИМЧАСОВА КНОПКА ДЛЯ КРАШУ ---
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextButton(
                          child: const Text(
                            "Згенерувати тестовий краш",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () {
                            FirebaseCrashlytics.instance.crash();
                          },
                        ),
                      ),
                    ),
                    // --- КІНЕЦЬ ТИМЧАСОВОЇ КНОПKI ---

                    const Text(
                      'Recent Activity',
                      style: TextStyle(color: kTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    ...recentActivities.map((activity) => _buildActivityTile(activity: activity)),
                    
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile({required Activity activity}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kInputFillColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: activity.iconColor.withAlpha(51), 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(activity.icon, color: activity.iconColor),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title, style: const TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(activity.details, style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 14)),
                ],
              ),
            ],
          ),
          Text(
            activity.timeAgo,
            style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kInputFillColor, 
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: kTextColor.withAlpha(178)),
      ),
      body: Center(
        child: Text(
          'Your notifications will appear here!',
          style: TextStyle(color: kTextColor.withAlpha(178), fontSize: 18),
        ),
      ),
    );
  }
}