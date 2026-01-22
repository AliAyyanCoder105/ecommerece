import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ReelApp());
}

class ReelApp extends StatelessWidget {
  const ReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: Colors.pinkAccent),
      ),
      home: const ReelFeedScreen(),
    );
  }
}

// --- Model ---
class Reel {
  final String username;
  final String caption;
  final String musicName;
  final String imageUrl;
  final String likes;
  final String comments;
  final Color themeColor;
  bool isFollowing;

  Reel({
    required this.username,
    required this.caption,
    required this.musicName,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.themeColor,
    this.isFollowing = false,
  });
}

// --- Main Feed ---
class ReelFeedScreen extends StatefulWidget {
  const ReelFeedScreen({super.key});

  @override
  State<ReelFeedScreen> createState() => _ReelFeedScreenState();
}

class _ReelFeedScreenState extends State<ReelFeedScreen> {
  final List<Reel> reels = [
    Reel(
      username: "cyber_punk_2024",
      caption: "Living in the future 🌃 #neon #vibes #tokyo",
      musicName: "Night City - Artemis (Original Sound)",
      imageUrl: "https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=1000",
      likes: "1.2M",
      comments: "12.5K",
      themeColor: Colors.cyanAccent,
    ),
    Reel(
      username: "nature_explore",
      caption: "Peace is found in the mountains 🏔️ #nature #trekking",
      musicName: "Forest Birds - Relaxing Sounds",
      imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1000",
      likes: "890K",
      comments: "4.2K",
      themeColor: Colors.greenAccent,
    ),
    Reel(
      username: "tech_reviewer",
      caption: "This new gadget is insane! 🤯 #tech #unboxing",
      musicName: "Synthwave Beats - Digital Artist",
      imageUrl: "https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1000",
      likes: "450K",
      comments: "8.1K",
      themeColor: Colors.purpleAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            itemBuilder: (context, index) => ReelItem(reel: reels[index]),
          ),
          // Top Navigation
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _topTab("Following", false),
                const SizedBox(width: 20),
                _topTab("For You", true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 35), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  Widget _topTab(String label, bool isActive) {
    return Text(label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.white : Colors.white60,
        ));
  }
}

// --- Individual Reel Item ---
class ReelItem extends StatefulWidget {
  final Reel reel;
  const ReelItem({super.key, required this.reel});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> with SingleTickerProviderStateMixin {
  late AnimationController _musicController;
  bool isLiked = false;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    _musicController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _musicController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    setState(() {
      isLiked = true;
      showHeart = true;
    });
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 800), () => setState(() => showHeart = false));
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const CommentSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (Video Placeholder)
          Image.network(widget.reel.imageUrl, fit: BoxFit.cover),

          // Overlay Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.3), Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
          ),

          // Right Sidebar Actions
          Positioned(
            right: 12,
            bottom: 100,
            child: Column(
              children: [
                _buildProfile(widget.reel),
                const SizedBox(height: 20),
                _sideAction(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: widget.reel.likes,
                  color: isLiked ? Colors.red : Colors.white,
                  onTap: () => setState(() => isLiked = !isLiked),
                ),
                _sideAction(icon: Icons.comment_rounded, label: widget.reel.comments, onTap: _showComments),
                _sideAction(icon: Icons.share, label: "Share"),
                const SizedBox(height: 10),
                _buildMusicDisk(),
              ],
            ),
          ),

          // Bottom Content
          Positioned(
            bottom: 20,
            left: 15,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("@${widget.reel.username}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text(widget.reel.caption, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.music_note, size: 15, color: Colors.white),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 200,
                      child: Text(widget.reel.musicName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Progress Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: 0.4, // Mock progress
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(widget.reel.themeColor),
              minHeight: 2,
            ),
          ),

          // Double Tap Heart Animation
          if (showHeart)
            Center(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.5, end: 1.2),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: const Icon(Icons.favorite, color: Colors.red, size: 120),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfile(Reel reel) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=a"),
          ),
        ),
        if (!reel.isFollowing)
          Positioned(
            bottom: -8,
            left: 18,
            child: GestureDetector(
              onTap: () => setState(() => widget.reel.isFollowing = true),
              child: Container(
                decoration: const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle),
                child: const Icon(Icons.add, size: 18, color: Colors.white),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildMusicDisk() {
    return RotationTransition(
      turns: _musicController,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const SweepGradient(colors: [Colors.black, Colors.grey, Colors.black]),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 4),
        ),
        child: const Icon(Icons.music_note, size: 20),
      ),
    );
  }

  Widget _sideAction({required IconData icon, required String label, Color color = Colors.white, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, size: 35, color: color),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// --- Comment Bottom Sheet ---
class CommentSheet extends StatelessWidget {
  const CommentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("12.5K Comments", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.blueGrey),
                title: Text("User_$index", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                subtitle: const Text("This is a flashy Reel! 🔥 Keep it up.", style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.favorite_border, size: 15),
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Add comment...",
              suffixIcon: const Icon(Icons.alternate_email, color: Colors.pinkAccent),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}