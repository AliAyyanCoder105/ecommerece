import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const UltraLuxuryReelApp());
}

class UltraLuxuryReelApp extends StatelessWidget {
  const UltraLuxuryReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Inter', letterSpacing: -0.5),
        ),
      ),
      home:  MainFeedScreen(),
    );
  }
}

/* ================= MODEL ================= */

class Reel {
  final String user, caption, music, image, likes, shares;
  final bool isViral;

  Reel(this.user, this.caption, this.music, this.image, this.likes, this.shares,
      {this.isViral = false});
}

/* ================= MAIN FEED ================= */

class MainFeedScreen extends StatelessWidget {
   MainFeedScreen({super.key});

  final List<Reel> reels =  [
    Reel(
      "aura.architect",
      "Restraint is the ultimate form of complexity.",
      "Solitude (Slowed) • Lofi",
      "https://images.unsplash.com/photo-1600607687940-c52af096999c?q=80&w=1000",
      "1.2M",
      "12K",
      isViral: true,
    ),
    Reel(
      "velvet.motion",
      "The beauty of moving slowly.",
      "Evergreen • Richy Mitch",
      "https://images.unsplash.com/photo-1500673922987-e212871fec22?q=80&w=1000",
      "840K",
      "5.2K",
    ),
    Reel(
      "ethereal.vibe",
      "Chasing light where it settles.",
      "Midnight City • M83",
      "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?q=80&w=1000",
      "2.4M",
      "45K",
      isViral: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
  late AnimationController _bgController;
  late AnimationController _heartController;
  bool _isLiked = false;
  bool _showHeartPop = false;

  @override
  void initState() {
    super.initState();
    // Ken Burns Effect (Slow zoom)
    _bgController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isLiked = true;
      _showHeartPop = true;
    });
    _heartController.forward(from: 0).then((_) {
      setState(() => _showHeartPop = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Cinematic Background
          ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.15).animate(
              CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
            ),
            child: Image.network(widget.reel.image, fit: BoxFit.cover),
          ),

          // 2. Luxury Vignette Overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4, 0.7, 1.0],
                colors: [
                  Colors.black54,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                ],
              ),
            ),
          ),

          // 3. Information & Layout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildUserSection(),
                        const SizedBox(height: 12),
                        Text(
                          widget.reel.caption,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildMusicPill(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  _buildSideActions(),
                ],
              ),
            ),
          ),

          // 4. Large Heart Pop Animation
          if (_showHeartPop)
            Center(
              child: FadeTransition(
                opacity: _heartController,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                      parent: _heartController, curve: Curves.elasticOut),
                  child: Icon(
                    Icons.favorite,
                    size: 120,
                    color: Colors.white.withOpacity(0.9),
                    shadows: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.5),
                        blurRadius: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),

          // 5. Luxury Progress Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: 0.4, // Mock value
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(Colors.white54),
              minHeight: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          child: const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=a"),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "@${widget.reel.user}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 10),
        if (widget.reel.isViral)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A30).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFFF8A30), width: 0.5),
            ),
            child: const Text("VIRAL",
                style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFFFF8A30),
                    fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildSideActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _glassAction(
          _isLiked ? Icons.favorite : Icons.favorite_outline,
          widget.reel.likes,
          _isLiked ? const Color(0xFFFF4B4B) : Colors.white,
              () {
            HapticFeedback.lightImpact();
            setState(() => _isLiked = !_isLiked);
          },
        ),
        _glassAction(Icons.chat_bubble_outline, "4.2K", Colors.white, () {}),
        _glassAction(Icons.send_outlined, widget.reel.shares, Colors.white, () {}),
        const SizedBox(height: 10),
        _rotatingMusicDisk(),
      ],
    );
  }

  Widget _glassAction(
      IconData icon, String label, Color iconColor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicPill() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.music_note_rounded, size: 14, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                widget.reel.music,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rotatingMusicDisk() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
      child: const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.black,
        child: Icon(Icons.audiotrack, size: 15, color: Colors.white),
      ),
    );
  }
}