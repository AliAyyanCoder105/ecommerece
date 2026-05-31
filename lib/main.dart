import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CoupleApp());
}

class CoupleApp extends StatelessWidget {
  const CoupleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Couple App',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime anniversaryDate = DateTime(2024, 1, 1);

  int totalDays = 0;

  final List<String> quotes = [
    "Every love story is beautiful ❤️",
    "You are my favorite notification 😄",
    "Together is my favorite place 💕",
    "Some souls just understand each other ✨",
  ];

  String currentQuote = "";

  @override
  void initState() {
    super.initState();
    loadDate();
  }

  Future<void> loadDate() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedDate = prefs.getString('anniversary');

    if (savedDate != null) {
      anniversaryDate = DateTime.parse(savedDate);
    }

    calculateDays();
  }

  Future<void> saveDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'anniversary',
      date.toIso8601String(),
    );
  }

  void calculateDays() {
    totalDays =
        DateTime.now().difference(anniversaryDate).inDays;

    currentQuote = quotes[
    totalDays % quotes.length];

    setState(() {});
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: anniversaryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      anniversaryDate = pickedDate;

      await saveDate(pickedDate);

      calculateDays();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // HEART ICON
                TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0.9,
                    end: 1.1,
                  ),

                  duration: const Duration(
                    seconds: 1,
                  ),

                  curve: Curves.easeInOut,

                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },

                  child: const Icon(
                    Icons.favorite,
                    color: Colors.pink,
                    size: 110,
                  ),
                ),

                const SizedBox(height: 30),

                // TITLE
                Text(
                  "Together For",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // DAYS
                Text(
                  "$totalDays Days ❤️",
                  style: GoogleFonts.poppins(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),

                const SizedBox(height: 20),

                // DATE
                Text(
                  "Since ${anniversaryDate.day}/${anniversaryDate.month}/${anniversaryDate.year}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                // QUOTE CARD
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),

                    borderRadius:
                    BorderRadius.circular(20),

                    border: Border.all(
                      color:
                      Colors.white.withOpacity(0.1),
                    ),
                  ),

                  child: Text(
                    currentQuote,
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // BUTTON
                ElevatedButton.icon(
                  onPressed: pickDate,

                  icon: const Icon(Icons.calendar_month),

                  label: const Text(
                    "Select Anniversary Date",
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}