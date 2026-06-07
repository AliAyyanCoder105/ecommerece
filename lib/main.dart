import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const StoryScreen(),
    );
  }
}

class StoryCard {
  final String frontTitle, frontEmoji, backEmoji, backNote;
  final Color glowColor;
  StoryCard({required this.frontTitle, required this.frontEmoji, required this.backEmoji, required this.backNote, required this.glowColor});
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  double _pageOffset = 0;
  bool _showLeftBtn = false, _showRightBtn = false;

  final List<List<StoryCard>> allPages = [
    [
      StoryCard(frontTitle: "Reveal ✨", frontEmoji: "🎂", backEmoji: "🎈", backNote: "Happy Birthday! Wishing you a day full of joy.", glowColor: Colors.pinkAccent),
      StoryCard(frontTitle: "Reveal ✨", frontEmoji: "🌸", backEmoji: "💐", backNote: "May your life bloom beautifully forever.", glowColor: Colors.indigoAccent),
      StoryCard(frontTitle: "Reveal ✨", frontEmoji: "⭐", backEmoji: "🌟", backNote: "Keep shining bright like the star you are.", glowColor: Colors.orangeAccent),
      StoryCard(frontTitle: "Reveal ✨", frontEmoji: "🧸", backEmoji: "🫂", backNote: "A big birthday hug for my favorite person.", glowColor: Colors.greenAccent),
    ],
    [
      StoryCard(frontTitle: "Surprise 🎁", frontEmoji: "🕯️", backEmoji: "🪄", backNote: "May all your secret wishes come true today.", glowColor: Colors.redAccent),
      StoryCard(frontTitle: "Memories 🎞️", frontEmoji: "📸", backEmoji: "💌", backNote: "Cherishing every moment we spend together.", glowColor: Colors.blueAccent),
      StoryCard(frontTitle: "Sweet ✨", frontEmoji: "🍰", backEmoji: "🍭", backNote: "Life is sweeter with you by my side.", glowColor: Colors.purpleAccent),
      StoryCard(frontTitle: "Promise ♾️", frontEmoji: "🔒", backEmoji: "🔑", backNote: "Forever isn't long enough with you.", glowColor: Colors.pink),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _pageController.addListener(() => setState(() => _pageOffset = _pageController.page ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD1DC), Color(0xFFE6E6FA), Color(0xFFFFFDD0)]))),
          const FloatingParticles(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildGradientProgressBar(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: allPages.length,
                    itemBuilder: (context, index) {
                      double scale = max(0.9, (1 - (_pageOffset - index).abs() * 0.1));
                      return Transform.scale(scale: scale, child: _buildPageGrid(index));
                    },
                  ),
                ),
                const SizedBox(height: 10), // Bottom padding
              ],
            ),
          ),

          _buildHoverNavButton(isLeft: true),
          _buildHoverNavButton(isLeft: false),
          Positioned(top: 40, right: 20, child: _circleIcon(Icons.music_note, Colors.pinkAccent)),
          Positioned(bottom: 20, right: 20, child: _circleIcon(Icons.volume_up, Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text("🧸", style: TextStyle(fontSize: 65)), // Slightly smaller bear to fit screen
        Text("Happy Birthday Honey! 🎂", style: GoogleFonts.dancingScript(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFFE91E63))),
        Text("Our Little Story", style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF331D32))),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("❤️", style: TextStyle(fontSize: 18)), SizedBox(width: 10), Text("❤️", style: TextStyle(fontSize: 18)), SizedBox(width: 10), Text("❤️", style: TextStyle(fontSize: 18))]),
      ],
    );
  }

  Widget _buildGradientProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      child: Column(
        children: [
          Text("Chapter ${(_pageOffset + 1).toInt()} of ${allPages.length}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFAD497B))),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * ((_pageOffset + 1) / allPages.length),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.orangeAccent]),
                      boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.4), blurRadius: 8)],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPageGrid(int pageIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Important: Prevents internal scroll
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05, // Made cards shorter to fit screen
        ),
        itemCount: allPages[pageIndex].length,
        itemBuilder: (context, i) => FlippableCard(cardData: allPages[pageIndex][i]),
      ),
    );
  }

  Widget _buildHoverNavButton({required bool isLeft}) {
    bool canGo = isLeft ? _pageOffset > 0.1 : _pageOffset < allPages.length - 1.1;
    return Positioned(
      left: isLeft ? 0 : null, right: isLeft ? null : 0, top: 100, bottom: 100,
      child: MouseRegion(
        onEnter: (_) => setState(() => isLeft ? _showLeftBtn = true : _showRightBtn = true),
        onExit: (_) => setState(() => isLeft ? _showLeftBtn = false : _showRightBtn = false),
        child: AnimatedOpacity(
          opacity: ((isLeft ? _showLeftBtn : _showRightBtn) && canGo) ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: 50,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [isLeft ? Colors.white24 : Colors.transparent, isLeft ? Colors.transparent : Colors.white24])),
            child: Center(child: Icon(isLeft ? Icons.chevron_left : Icons.chevron_right, size: 40, color: Colors.pinkAccent)),
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, Color col) => Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]), child: Icon(icon, color: col, size: 20));
}

// --- FLIPPABLE CARD ---
class FlippableCard extends StatefulWidget {
  final StoryCard cardData;
  const FlippableCard({super.key, required this.cardData});
  @override State<FlippableCard> createState() => _FlippableCardState();
}
class _FlippableCardState extends State<FlippableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFlipped = false;
  @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500)); }
  @override void dispose() { _controller.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { setState(() => _isFlipped = !_isFlipped); _isFlipped ? _controller.forward() : _controller.reverse(); },
      child: AnimatedBuilder(animation: _controller, builder: (context, child) {
        final angle = _controller.value * pi;
        return Transform(
          transform: Matrix4.identity()..setEntry(3, 2, 0.0015)..rotateY(angle), alignment: Alignment.center,
          child: angle < pi / 2
              ? _buildSide(widget.cardData.frontTitle, widget.cardData.frontEmoji, true)
              : Transform(transform: Matrix4.identity()..rotateY(pi), alignment: Alignment.center, child: _buildSide(widget.cardData.backNote, widget.cardData.backEmoji, false)),
        );
      }),
    );
  }

  Widget _buildSide(String text, String icon, bool isFront) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: widget.cardData.glowColor.withOpacity(0.3), blurRadius: 10)]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(icon, style: TextStyle(fontSize: 35, shadows: [Shadow(color: widget.cardData.glowColor.withOpacity(0.4), blurRadius: 8)])),
        const SizedBox(height: 5),
        Text(text, textAlign: TextAlign.center, style: isFront ? GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFAD497B)) : GoogleFonts.dancingScript(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF331D32))),
      ]),
    );
  }
}

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key});
  @override State<FloatingParticles> createState() => _FloatingParticlesState();
}
class _FloatingParticlesState extends State<FloatingParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(); }
  @override void dispose() { _controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _controller, builder: (context, child) {
      return Stack(children: List.generate(15, (i) {
        double x = (sin(i + _controller.value * 6) + 1) / 2 * MediaQuery.of(context).size.width;
        double y = (1 - ((_controller.value + i / 15) % 1)) * MediaQuery.of(context).size.height;
        return Positioned(left: x, top: y, child: Opacity(opacity: 0.2, child: Text(i % 2 == 0 ? "💖" : "✨", style: const TextStyle(fontSize: 14))));
      }));
    });
  }
}