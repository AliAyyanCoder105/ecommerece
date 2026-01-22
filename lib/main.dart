import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const UltraPremiumReelApp());
}

class UltraPremiumReelApp extends StatelessWidget {
  const UltraPremiumReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF0050),
          secondary: Color(0xFF00F2EA),
          tertiary: Color(0xFFFFD700),
        ),
      ),
      home: const MainFeedScreen(),
    );
  }
}

class Reel {
  final String user, caption, music, url, likes, comments;
  final bool isViral;
  Reel(this.user, this.caption, this.music, this.url, this.likes, this.comments, {this.isViral = false});
}

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  final List<Reel> reels = [
    Reel("aura_design", "Defining the future of mobile interfaces 🚀 #ux #ui #flutter", "Inception Theme - Hans Zimmer", "https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=1000", "2.4M", "18K", isViral: true),
    Reel("wanderlust", "Midnight in the Maldives is a dream.. ✨", "Ocean Waves - Lofi Girl", "https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=1000", "950K", "5.2K"),
    Reel("neon_racer", "Nothing beats the night drive 🏎️💨", "Phonk Killer - Tokyo", "https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=1000", "1.1M", "9K", isViral: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            itemBuilder: (context, index) => UltraReelItem(reel: reels[index]),
          ),

          // Floating Top Navigation
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _topNavItem("Following", false),
                      const SizedBox(width: 30),
                      _topNavItem("For You", true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPremiumBottomBar(),
    );
  }

  Widget _topNavItem(String title, bool active) {
    return AnimatedScale(
      scale: active ? 1.1 : 0.9,
      duration: const Duration(milliseconds: 200),
      child: Text(title, style: TextStyle(
        color: active ? Colors.white : Colors.white38,
        fontSize: 18,
        fontWeight: active ? FontWeight.w900 : FontWeight.w500,
        shadows: active ? [const Shadow(color: Colors.white24, blurRadius: 10)] : [],
      )),
    );
  }

  Widget _buildPremiumBottomBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _barIcon(Icons.grid_view_rounded, true),
          _barIcon(Icons.search_rounded, false),
          _createButton(),
          _barIcon(Icons.notifications_none_rounded, false),
          _barIcon(Icons.person_outline_rounded, false),
        ],
      ),
    );
  }

  Widget _barIcon(IconData icon, bool selected) {
    return Icon(icon, size: 28, color: selected ? Colors.white : Colors.white38);
  }

  Widget _createButton() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFF00F2EA), Color(0xFFFF0050)]),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class UltraReelItem extends StatefulWidget {
  final Reel reel;
  const UltraReelItem({super.key, required this.reel});

  @override
  State<UltraReelItem> createState() => _UltraReelItemState();
}

class _UltraReelItemState extends State<UltraReelItem> with TickerProviderStateMixin {
  late AnimationController _diskController;
  late AnimationController _heartController;
  bool isLiked = false;
  bool showLargeHeart = false;

  @override
  void initState() {
    super.initState();
    _diskController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _heartController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _diskController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    setState(() { isLiked = true; showLargeHeart = true; });
    HapticFeedback.heavyImpact();
    _heartController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () => setState(() => showLargeHeart = false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Media
          Image.network(widget.reel.url, fit: BoxFit.cover),

          // Mesh Gradient Overlay for Depth
          _buildMeshOverlay(),

          // Side Action Sidebar (Staggered Animation Feel)
          Positioned(
            right: 15,
            bottom: 100,
            child: Column(
              children: [
                _buildProfile(widget.reel.isViral),
                const SizedBox(height: 25),
                _squishButton(Icons.favorite, widget.reel.likes, isLiked ? Colors.redAccent : Colors.white, () {
                  setState(() => isLiked = !isLiked);
                  HapticFeedback.selectionClick();
                }),
                _squishButton(Icons.mode_comment_rounded, widget.reel.comments, Colors.white, () {}),
                _squishButton(Icons.send_rounded, "Share", Colors.white, () {}),
                _squishButton(Icons.more_horiz_rounded, "", Colors.white, () {}),
                const SizedBox(height: 15),
                _rotatingMusicDisk(),
              ],
            ),
          ),

          // Info Overlay
          Positioned(
            bottom: 30,
            left: 20,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("@${widget.reel.user}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, color: Color(0xFF00F2EA), size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Text(widget.reel.caption, style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4)),
                const SizedBox(height: 18),
                _buildMusicMarquee(),
              ],
            ),
          ),

          // Double Tap Heart Burst
          if (showLargeHeart)
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
                child: Icon(Icons.favorite, color: Colors.white.withOpacity(0.9), size: 130, shadows: [
                  BoxShadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 40, spreadRadius: 10),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMeshOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.7, 1.0],
          colors: [
            Colors.black.withOpacity(0.5),
            Colors.transparent,
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(bool viral) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: viral ? [Colors.cyan, Colors.purple, Colors.orange, Colors.cyan] : [Colors.white24, Colors.white24]),
          ),
          child: const CircleAvatar(radius: 28, backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=22")),
        ),
        Positioned(
          bottom: -8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0050),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5)],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 14),
          ),
        )
      ],
    );
  }

  Widget _squishButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 52, width: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicMarquee() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_note_rounded, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          const Text("Original Sound • ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(widget.reel.music, style: const TextStyle(fontSize: 13, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _rotatingMusicDisk() {
    return RotationTransition(
      turns: _diskController,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,

          border: Border.all(color: Colors.white10, width: 4),
        ),
        child: const CircleAvatar(radius: 12, backgroundColor: Colors.black, child: Icon(Icons.audiotrack_rounded, size: 12, color: Colors.white38)),
      ),
    );
  }
}