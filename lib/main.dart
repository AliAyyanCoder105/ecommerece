import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FoodPickerApp());
}

class FoodPickerApp extends StatelessWidget {
  const FoodPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home: const FoodHome(),
    );
  }
}

class FoodHome extends StatefulWidget {
  const FoodHome({super.key});

  @override
  State<FoodHome> createState() => _FoodHomeState();
}

class _FoodHomeState extends State<FoodHome>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> foods = List.generate(40, (i) {
    final allFoods = [
      ["Biryani", "🍛"],
      ["Zinger Burger", "🍔"],
      ["Chicken Karahi", "🍗"],
      ["Pizza", "🍕"],
      ["Fries", "🍟"],
      ["Shawarma", "🥙"],
      ["Pasta Alfredo", "🍝"],
      ["Steak", "🥩"],
      ["Noodles", "🍜"],
      ["Sushi", "🍣"],
      ["Tacos", "🌮"],
      ["Qorma", "🍲"],
      ["Paratha Roll", "🌯"],
      ["BBQ Tikka", "🍖"],
      ["Ice Cream", "🍨"],
      ["Cold Coffee", "🥤"],
      ["Daal Chawal", "🍚"],
      ["Gol Gappay", "🥟"],
      ["Milkshake", "🍧"],
      ["Donuts", "🍩"],
      ["Fried Fish", "🐟"],
      ["Mutton Karahi", "🍖"],
      ["Aloo Ke Parathay", "🥘"],
      ["Momos", "🥟"],
      ["Veg Salad", "🥗"],
      ["Halwa Puri", "🍥"],
      ["Kebab Platter", "🍢"],
      ["Broast", "🍗"],
      ["Lemonade", "🍋"],
      ["Chocolate Cake", "🍰"],
    ];
    return {
      "name": allFoods[i % allFoods.length][0],
      "emoji": allFoods[i % allFoods.length][1],
    };
  });

  String selectedFood = "";
  String selectedEmoji = "";

  late AnimationController spinController;

  @override
  void initState() {
    super.initState();
    spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  void spin() {
    spinController.forward(from: 0);

    final random = Random();
    final item = foods[random.nextInt(foods.length)];

    setState(() {
      selectedFood = item["name"]!;
      selectedEmoji = item["emoji"]!;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      showResultDialog();
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => ScaleTransition(
        scale: CurvedAnimation(parent: spinController, curve: Curves.elasticOut),
        child: Dialog(
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your Fate",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "$selectedFood $selectedEmoji🔥",
                  style: const TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Spin Again"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingEmoji(double top, double left, String emoji) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: spinController,
        builder: (_, child) => Transform.rotate(
          angle: spinController.value * 3,
          child: child,
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✨ Liquid Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF5F6D), Color(0xffFFC371)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          floatingEmoji(80, 40, "🍕"),
          floatingEmoji(200, 300, "🍔"),
          floatingEmoji(500, 100, "🍣"),
          floatingEmoji(400, 250, "🥙"),
          floatingEmoji(150, 210, "🍟"),

          Center(
            child: ScaleTransition(
              scale:
              CurvedAnimation(parent: spinController, curve: Curves.easeOut),
              child: Container(
                padding: const EdgeInsets.all(60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.4)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Text(
                  "🍽️",
                  style: TextStyle(fontSize: 70),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.25),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                onPressed: spin,
                child: const Text(
                  "Spin the Wheel 🎯",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
