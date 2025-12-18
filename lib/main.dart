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
      theme: ThemeData.dark(),
      home: const TournamentWebPosterPage(),
    );
  }
}

class TournamentWebPosterPage extends StatelessWidget {
  const TournamentWebPosterPage({super.key});

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
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
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
              Container(color: Colors.black.withOpacity(0.82)),

              Center(
                child: Container(
                  width: constraints.maxWidth > 1200
                      ? 1200
                      : constraints.maxWidth * 0.96,
                  height: constraints.maxHeight * 0.94,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      /// HEADER
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.greenAccent, Colors.teal],
                          ),
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: const [
                            BoxShadow(color: Colors.black54, blurRadius: 20)
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "خوش آمدید",
                              style: GoogleFonts.amiri(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "ڈبل وکٹ کرکٹ ٹورنامنٹ",
                              style: GoogleFonts.amiri(
                                fontSize: 18,
                                color: Colors.yellowAccent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// BODY
                      Expanded(
                        child: Row(
                          children: [
                            /// LEFT – INFO
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ٹورنامنٹ کی شرائط",
                                      style: GoogleFonts.amiri(
                                        fontSize: 22,
                                        color: Colors.lightGreenAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "• تمام ٹیمیں وقت پر گراؤنڈ میں موجود ہوں\n"
                                          "• لیٹ ٹیم کو شامل نہیں کیا جائے گا\n"
                                          "• امپائر کا فیصلہ حتمی ہوگا",
                                      style: GoogleFonts.notoNastaliqUrdu(
                                        fontSize: 14,
                                        height: 2.1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.orange,
                                            Colors.deepOrange
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Text(
                                        "انٹری فیس: 500 روپے",
                                        textAlign: TextAlign.center,
                                        style:
                                        GoogleFonts.notoNastaliqUrdu(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 24),


                            Expanded(
                              flex: 3,
                              child: GridView.count(
                                physics:
                                const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                childAspectRatio: 0.78,
                                children: players.map((p) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(24),
                                      border:
                                      Border.all(color: Colors.white24),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.greenAccent,
                                                Colors.teal
                                              ],
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                            AssetImage(p.image),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          p.name,
                                          style:
                                          GoogleFonts.notoNastaliqUrdu(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// FOOTER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.redAccent, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "رابطہ کریں: 0328-1276911",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
