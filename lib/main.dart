import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class Player {
  final String name;
  final String image;
  const Player({required this.name, required this.image});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const TournamentMobilePage(),
    );
  }
}

class TournamentMobilePage extends StatelessWidget {
  const TournamentMobilePage({super.key});

  final List<Player> players = const [
    Player(name: "طلحہ", image: "assets/images/talha.png"),
    Player(name: "احمد", image: "assets/images/bagi.png"),
    Player(name: "ریحان", image: "assets/images/rehan.png"),
    Player(name: "عثمان", image: "assets/images/usman.png"),
    Player(name: "نادر", image: "assets/images/nadir.png"),
    Player(name: "عبد اللہ", image: "assets/images/p6.png"),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.75)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  /// HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff00c853), Color(0xff009688)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "خوش آمدید",
                          style: GoogleFonts.amiri(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "ڈبل وکٹ ٹورنامنٹ",
                          style: GoogleFonts.amiri(
                            fontSize: 15,
                            color: Colors.yellowAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ENTRY FEE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      "انٹری فیس: 500 روپے",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// RULES CARD
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ٹورنامنٹ کی شرائط",
                          style: GoogleFonts.amiri(
                            fontSize: 18,
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "• تمام ٹیمیں وقت پر گراؤنڈ میں موجود ہوں\n"
                              "• لیٹ آنے والی ٹیم نااہل ہوگی\n"
                              "• امپائر کا فیصلہ حتمی ہوگا",
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 13,
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PLAYERS GRID
                  Expanded(
                    child: Column(
                      children: [
                        _playerRow(context, players.sublist(0, 3)),
                        const SizedBox(height: 12),
                        _playerRow(context, players.sublist(3, 6)),
                      ],
                    ),
                  ),

                  /// CONTACT
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.redAccent, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Text(
                      "رابطہ کریں: 0328‑1276911",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PLAYER ROW
  Widget _playerRow(BuildContext context, List<Player> rowPlayers) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Row(
        children: rowPlayers.map((player) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.greenAccent, Colors.teal],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: width * 0.11,
                    backgroundImage: AssetImage(player.image),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  player.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
