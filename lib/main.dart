import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const UltraLuxuryReelApp());
}

/* ================= APP ================= */

class UltraLuxuryReelApp extends StatelessWidget {
  const UltraLuxuryReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0B0C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8A30), // warm luxury amber
          secondary: Color(0xFF5E5CE6), // apple violet
        ),
      ),
      home:  MainFeedScreen(),
    );
  }
}

/* ================= MODEL ================= */

class Reel {
  final String user, caption, music, image, likes;
  final bool isViral;

  Reel(
      this.user,
      this.caption,
      this.music,
      this.image,
      this.likes, {
        this.isViral = false,
      });
}

/* ================= MAIN FEED ================= */

class MainFeedScreen extends StatelessWidget {
   MainFeedScreen({super.key});

  final List<Reel> reels = [
    Reel(
      "aura.design",
      "Design is not decoration.\nIt’s restraint.",
      "Original Sound · Minimal",
      "https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=1000",
      "2.4M",
      isViral: true,
    ),
    Reel(
      "wander.lux",
      "Silence is the new luxury.",
      "Ocean Drift · Ambient",
      "https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=1000",
      "980K",
    ),
    Reel(
      "midnight.drive",
      "Motion without noise.",
      "Night Drive · Synth",
      "https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=1000",
      "1.1M",
      isViral: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (_, i) => UltraReelItem(reel: reels[i]),
      ),
    );
  }
}

/* ================= REEL ITEM ================= */

class UltraReelItem extends StatefulWidget {
  final Reel reel;
  const UltraReelItem({super.key, required this.reel});

  @override
  State<UltraReelItem> createState() => _UltraReelItemState();
}

class _UltraReelItemState extends State<UltraReelItem>
    with TickerProviderStateMixin {
  late AnimationController _disk;
  late AnimationController _heart;
  bool liked = false;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    _disk =
    AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
    _heart =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _disk.dispose();
    _heart.dispose();
    super.dispose();
  }

  void _like() {
    HapticFeedback.mediumImpact();
    setState(() {
      liked = true;
      showHeart = true;
    });
    _heart.forward(from: 0).then((_) {
      Future.delayed(
        const Duration(milliseconds: 500),
            () => setState(() => showHeart = false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _like,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(widget.reel.image, fit: BoxFit.cover),

          // soft depth overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),

          // right actions
          Positioned(
            right: 18,
            bottom: 120,
            child: Column(
              children: [
                _profile(widget.reel.isViral),
                const SizedBox(height: 22),
                _action(
                  Icons.favorite,
                  widget.reel.likes,
                  liked ? const Color(0xFFFF8A30) : Colors.white70,
                      () => setState(() => liked = !liked),
                ),
                _action(Icons.send_rounded, "Share", Colors.white70, () {}),
                const SizedBox(height: 18),
                _musicDisk(),
              ],
            ),
          ),

          // text info
          Positioned(
            left: 22,
            right: 120,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.reel.user}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.reel.caption,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 18),
                _musicPill(),
              ],
            ),
          ),

          // calm heart
          if (showHeart)
            Center(
              child: ScaleTransition(
                scale:
                CurvedAnimation(parent: _heart, curve: Curves.easeOutBack),
                child: Icon(
                  Icons.favorite,
                  size: 110,
                  color: Colors.white.withOpacity(0.85),
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 40)
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _profile(bool viral) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: viral
            ? const LinearGradient(
          colors: [Color(0xFFFF8A30), Color(0xFF5E5CE6)],
        )
            : null,
      ),
      child: const CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=12"),
      ),
    );
  }

  Widget _action(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(color: Colors.white10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  Widget _musicPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_note, size: 14),
          const SizedBox(width: 8),
          Text(widget.reel.music,
              style: const TextStyle(fontSize: 13, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _musicDisk() {
    return RotationTransition(
      turns: _disk,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10, width: 3),
        ),
        child: const Icon(Icons.audiotrack, size: 14, color: Colors.white38),
      ),
    );
  }
}
