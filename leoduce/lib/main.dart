// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(LeoDanceApp());
}

class LeoDanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEO Dance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LeoHome(),
    );
  }
}

class LeoHome extends StatefulWidget {
  @override
  State<LeoHome> createState() => _LeoHomeState();
}

class _LeoHomeState extends State<LeoHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DanceCategories(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LEO Dance App"),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(icon: Icon(Icons.music_note), label: "Dance"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/* ---------------- Home Page ---------------- */
class HomePage extends StatelessWidget {
  final List<String> trending = [
    "Afro Dance",
    "Hip Hop",
    "Amapiano",
    "Breakdance",
    "Cultural Moves"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text("🔥 Trending Now",
            style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trending.length,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill,
                        size: 60, color: Colors.deepPurple),
                    SizedBox(height: 10),
                    Text(trending[index],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Text("✨ Featured Performers",
            style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 12),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text("Leo The Dancer"),
          subtitle: Text("Afro + Hip Hop Mix"),
          trailing: Icon(Icons.star, color: Colors.amber),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text("Aisha Groove"),
          subtitle: Text("Amapiano Specialist"),
          trailing: Icon(Icons.star, color: Colors.amber),
        ),
      ],
    );
  }
}

/* ---------------- Dance Categories ---------------- */
class DanceCategories extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"name": "Afro Dance", "icon": Icons.public},
    {"name": "Hip Hop", "icon": Icons.bolt},
    {"name": "Amapiano", "icon": Icons.music_note},
    {"name": "Breakdance", "icon": Icons.sports_gymnastics},
    {"name": "Traditional", "icon": Icons.festival},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 150,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Opening ${categories[index]['name']}")),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categories[index]['icon'], size: 50, color: Colors.deepPurple),
                SizedBox(height: 10),
                Text(categories[index]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ---------------- Profile Page ---------------- */
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text("LEO User",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 6),
            Text("Dance Enthusiast"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.settings),
              label: Text("Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
