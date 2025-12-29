import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const GiggleApp());
}

class GiggleApp extends StatelessWidget {
  const GiggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Giggle Generator',
      theme: ThemeData.dark(),
      home: const GiggleHome(),
    );
  }
}

class GiggleHome extends StatefulWidget {
  const GiggleHome({super.key});

  @override
  State<GiggleHome> createState() => _GiggleHomeState();
}

class _GiggleHomeState extends State<GiggleHome>
    with SingleTickerProviderStateMixin {
  final word1Controller = TextEditingController();
  final word2Controller = TextEditingController();

  String joke = "Do lafz likho… joker ready hai 🤡";
  String emoji = "😄";

  late AnimationController _controller;
  late Animation<double> _scale;

  final random = Random();

  final List<String> emojis = ["😂", "🤣", "😜", "🤡", "😆", "😎"];

  final List<String> templates = [
    "Aaj {w1} ne {w2} ko dekh kar resign de diya.",
    "{w1} bola: main serious hoon. {w2} hans hans ke gir gaya.",
    "Doctor ne kaha: zyada {w1} mat socho, warna {w2} ho jayega.",
    "Life lesson: jab {w1} aaye, to {w2} bhool jao.",
    "Breaking News 🚨: {w1} aur {w2} ki dosti khataray mein!",
    "{w1} ne kaha trust me bro… {w2} ne uninstall kar diya.",
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  void generateJoke() {
    if (word1Controller.text.isEmpty ||
        word2Controller.text.isEmpty) {
      setState(() {
        joke = "Aray bhai 😒 dono words likho, phir hansna";
        emoji = "🙄";
      });
      return;
    }

    final template = templates[random.nextInt(templates.length)];

    setState(() {
      joke = template
          .replaceAll("{w1}", word1Controller.text)
          .replaceAll("{w2}", word2Controller.text);
      emoji = emojis[random.nextInt(emojis.length)];
    });

    _controller.forward(from: 0);
  }

  void shareJoke() {
    Share.share("$emoji $joke\n\n— Giggle Generator 😄");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2C), Color(0xFF232526)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "😄 Giggle Generator",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _prettyField(word1Controller, "Word 1"),
                const SizedBox(height: 12),
                _prettyField(word2Controller, "Word 2"),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: generateJoke,
                  child: const Text("Generate Giggle 🎲"),
                ),

                const SizedBox(height: 25),

                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          joke,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: shareJoke,
                  icon: const Icon(Icons.share, size: 30),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _prettyField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
