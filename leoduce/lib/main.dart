// main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(LeoDancingApp());
}

class LeoDancingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leo — Dancing App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MainScaffold(),
    );
  }
}

/* ---------------- Main Scaffold / Navigation ---------------- */
class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final _pages = [
    HomePage(),
    StudioPage(),
    ChallengesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leo — Dance with Joy'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.music_note),
            tooltip: 'Music settings (TODO)',
            onPressed: () {
              // TODO: open music player or music settings (integrate just_audio / assets_audio_player)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Music settings — coming soon')));
            },
          )
        ],
      ),
      body: AnimatedSwitcher(duration: Duration(milliseconds: 300), child: _pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.videocam_outlined), label: 'Studio'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), label: 'Challenges'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: start recording via camera plugin
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record dance — camera integration TODO')));
              },
              icon: Icon(Icons.fiber_manual_record),
              label: Text('Record'),
            )
          : null,
    );
  }
}

/* ---------------- Home Page: Lessons & Leo Avatar ---------------- */
class HomePage extends StatelessWidget {
  final lessons = [
    DanceLesson(title: 'Beginner: Basic Steps', duration: '4 min', level: 'Beginner'),
    DanceLesson(title: 'Groove: Hip Swing', duration: '6 min', level: 'Beginner'),
    DanceLesson(title: 'Intermediate: Footwork', duration: '8 min', level: 'Intermediate'),
    DanceLesson(title: 'Advanced: Freestyle Combo', duration: '10 min', level: 'Advanced'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeoCard(),
          SizedBox(height: 16),
          Text('Lessons', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 12),
          ListView.separated(
            itemCount: lessons.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: 8),
            itemBuilder: (context, i) {
              final l = lessons[i];
              return LessonTile(lesson: l);
            },
          ),
          SizedBox(height: 20),
          Text('Quick Moves', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              QuickMoveChip(label: 'Step-Touch'),
              QuickMoveChip(label: 'Grapevine'),
              QuickMoveChip(label: 'Body Roll'),
              QuickMoveChip(label: 'Spin'),
              QuickMoveChip(label: 'Pose'),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

/* ---------- Leo Avatar Card with simple "dance" animation ---------- */
class LeoCard extends StatefulWidget {
  @override
  _LeoCardState createState() => _LeoCardState();
}

class _LeoCardState extends State<LeoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  bool _isDancing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    _controller.repeat(reverse: true);
    _isDancing = true;
    // Toggle subtle dance booster periodically
    _timer = Timer.periodic(Duration(seconds: 7), (_) {
      setState(() => _isDancing = !_isDancing);
      if (_isDancing) _controller.repeat(reverse: true);
      else _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                final tilt = math.sin(_controller.value * math.pi * 2) * 0.08;
                final bob = math.sin(_controller.value * math.pi * 2) * 6;
                return Transform.translate(
                  offset: Offset(0, bob),
                  child: Transform.rotate(
                    angle: tilt,
                    child: child,
                  ),
                );
              },
              child: LeoAvatar(size: 110),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leo — Your Dance Buddy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 6),
                  Text('Follow lessons, record your moves, and join challenges.'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: start quick lesson or start music
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Play quick lesson — TODO')));
                        },
                        icon: Icon(Icons.play_arrow),
                        label: Text('Quick Play'),
                      ),
                      SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: open avatar customization
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Customize Leo — TODO')));
                        },
                        icon: Icon(Icons.brush),
                        label: Text('Customize'),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LeoAvatar extends StatelessWidget {
  final double size;
  LeoAvatar({this.size = 80});
  @override
  Widget build(BuildContext context) {
    // Simple stylized avatar for Leo (circle + mane)
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.orange.shade200,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
          ),
        ),
        // mane
        Positioned(
          left: 0,
          child: Container(width: size * 0.3, height: size * 0.3, decoration: BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle)),
        ),
        Positioned(
          right: 0,
          child: Container(width: size * 0.3, height: size * 0.3, decoration: BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle)),
        ),
        // eyes
        Positioned(
          top: size * 0.35,
          child: Row(
            children: [
              Container(width: size * 0.12, height: size * 0.12, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
              SizedBox(width: size * 0.16),
              Container(width: size * 0.12, height: size * 0.12, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
            ],
          ),
        ),
        // smile
        Positioned(
            bottom: size * 0.22,
            child: Icon(Icons.favorite, size: size * 0.15, color: Colors.redAccent.withOpacity(0.7))),
      ],
    );
  }
}

/* ---------------- Lesson Tile ---------------- */
class DanceLesson {
  final String title;
  final String duration;
  final String level;
  DanceLesson({required this.title, required this.duration, required this.level});
}

class LessonTile extends StatelessWidget {
  final DanceLesson lesson;
  LessonTile({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.music_video)),
        title: Text(lesson.title),
        subtitle: Text('${lesson.level} • ${lesson.duration}'),
        trailing: ElevatedButton(
          child: Text('Start'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => LessonPlayerPage(lesson: lesson)));
          },
        ),
      ),
    );
  }
}

/* ---------------- Quick Move Chip ---------------- */
class QuickMoveChip extends StatelessWidget {
  final String label;
  QuickMoveChip({required this.label});
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try the $label move!')));
      },
    );
  }
}

/* ---------------- Lesson Player Page (placeholder for video + music) ---------------- */
class LessonPlayerPage extends StatefulWidget {
  final DanceLesson lesson;
  LessonPlayerPage({required this.lesson});

  @override
  _LessonPlayerPageState createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  bool _playing = false;
  double _progress = 0;
  Timer? _timer;

  void _togglePlay() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _timer = Timer.periodic(Duration(milliseconds: 400), (t) {
        setState(() {
          _progress += 0.02;
          if (_progress >= 1) {
            _progress = 1;
            _playing = false;
            t.cancel();
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // Placeholder for a video player / choreography animation
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.ondemand_video, size: 80, color: Colors.grey.shade600),
                      SizedBox(height: 12),
                      Text('Lesson video / choreography goes here', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),
            LinearProgressIndicator(value: _progress),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(icon: Icon(_playing ? Icons.pause_circle : Icons.play_circle), iconSize: 40, onPressed: _togglePlay),
                SizedBox(width: 8),
                Expanded(child: Text('${( _progress*100 ).toStringAsFixed(0)}%')),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.download_outlined),
                  onPressed: () {
                    // TODO: Download lesson for offline viewing
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download — TODO')));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/* ---------------- Studio Page: Record + Playback (UI) ---------------- */
class StudioPage extends StatefulWidget {
  @override
  _StudioPageState createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  bool _isRecording = false;
  List<String> _recordings = [];

  void _toggleRecord() {
    setState(() => _isRecording = !_isRecording);
    if (!_isRecording) {
      // simulate saved recording
      _recordings.insert(0, 'Dance_${DateTime.now().millisecondsSinceEpoch}.mp4');
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isRecording ? 'Recording...' : 'Recording saved')));
    // TODO: integrate camera and storage using `camera` and `path_provider` + `video_player`
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Studio'),
              subtitle: Text('Record your dance or play previous recordings'),
              trailing: ElevatedButton.icon(
                icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
                label: Text(_isRecording ? 'Stop' : 'Record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.red : null,
                ),
                onPressed: _toggleRecord,
              ),
            ),
          ),
          SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: Text('My Recordings', style: Theme.of(context).textTheme.titleMedium)),
          SizedBox(height: 8),
          Expanded(
            child: _recordings.isEmpty
                ? Center(child: Text('No recordings yet — press Record to start'))
                : ListView.separated(
                    itemCount: _recordings.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, i) {
                      final r = _recordings[i];
                      return ListTile(
                        leading: Icon(Icons.play_circle_outline),
                        title: Text(r),
                        subtitle: Text('3.2 MB (simulated)'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'play') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Play $r — TODO')));
                            } else if (v == 'share') {
                              // TODO: integrate share_plus to share files
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share $r — TODO')));
