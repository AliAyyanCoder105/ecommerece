import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // For ImageFilter
import 'dart:async';

// --- Data Model ---
class CartItem {
  final String title;
  final String price;
  final String img;
  int quantity;
  CartItem({required this.title, required this.price, required this.img, this.quantity = 1});
}

// --- Cart Service ---
class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  final StreamController<List<CartItem>> _cartStream = StreamController.broadcast();
  Stream<List<CartItem>> get cartStream => _cartStream.stream;

  void add(CartItem item) {
    bool found = false;
    for (var cartItem in _items) {
      if (cartItem.title == item.title) {
        cartItem.quantity += item.quantity;
        found = true;
        break;
      }
    }
    if (!found) _items.add(item);
    _cartStream.add(_items);
  }

  void remove(CartItem item) {
    _items.remove(item);
    _cartStream.add(_items);
  }

  void increment(CartItem item) {
    item.quantity++;
    _cartStream.add(_items);
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) item.quantity--;
    _cartStream.add(_items);
  }

  double getTotalPrice() {
    return _items.fold(0, (total, current) {
      final price = double.tryParse(current.price.replaceAll('\$', '').replaceAll(',', '')) ?? 0;
      return total + (price * current.quantity);
    });
  }
}

final cartService = CartService();

// --- DARK LUXURY THEME PALETTE ---
const Color kBgColor = Color(0xFF121212);      // Very Dark Grey
const Color kCardColor = Color(0xFF1E1E1E);    // Dark Matte Grey
const Color kGoldColor = Color(0xFFD4AF37);    // Champagne Gold
const Color kTextColor = Color(0xFFEDEDED);    // Off-white
const Color kSubTextColor = Color(0xFF888888); // Grey

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: kBgColor,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const DreamLifeApp());
}

class DreamLifeApp extends StatelessWidget {
  const DreamLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dream Life Dark",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBgColor,
        primaryColor: kGoldColor,
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.cinzel(fontSize: 32, fontWeight: FontWeight.bold, color: kTextColor),
          displayMedium: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: kTextColor),
          bodyLarge: GoogleFonts.lato(fontSize: 16, color: kTextColor),
          bodyMedium: GoogleFonts.lato(fontSize: 14, color: kSubTextColor),
        ),
        colorScheme: const ColorScheme.dark(
          primary: kGoldColor,
          surface: kCardColor,
          background: kBgColor,
          secondary: kGoldColor,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- Main Navigation ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    DiscoverScreen(),
    const CategoriesScreen(),
    CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildDarkGlassNavigationBar(),
    );
  }

  Widget _buildDarkGlassNavigationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.grid_view_rounded, 0),
                _navItem(Icons.category_outlined, 1),
                _navItem(Icons.shopping_bag_outlined, 2),
                _navItem(Icons.person_outline_rounded, 3),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1, duration: 800.ms, curve: Curves.easeOutQuart);
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? kGoldColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white54,
          size: 24,
        ),
      ),
    );
  }
}

// --- Discover Screen ---
class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({super.key});

  // IMPORTANT: Ensure these files exist in assets/images/
  final categoryData = [
    {"title": "Armchairs", "img": "assets/images/chair1.png"},
    {"title": "Lamps", "img": "assets/images/lamp1.png"},
    {"title": "Dining", "img": "assets/images/table1.png"},
    {"title": "Decor", "img": "assets/images/vase1.png"},
  ];

  final productData = [
    {"title": "Noir Velvet Sofa", "price": "\$1,299", "rating": 4.9, "img": "assets/images/sofa_black.png"},
    {"title": "Industrial Lamp", "price": "\$189", "rating": 4.6, "img": "assets/images/lamp2.png"},
    {"title": "Eames Classic", "price": "\$2,400", "rating": 5.0, "img": "assets/images/chair2.png"},
    {"title": "Obsidian Table", "price": "\$850", "rating": 4.7, "img": "assets/images/table1.png"},
    {"title": "Slate Bed Frame", "price": "\$1,100", "rating": 4.8, "img": "assets/images/bed1.png"},
    {"title": "Accent Vase", "price": "\$89", "rating": 4.5, "img": "assets/images/vase2.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: kBgColor,
            elevation: 0,
            floating: true,
            centerTitle: true,
            title: Text("DREAM LIFE", style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4, color: kTextColor)),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none, color: kTextColor))
            ],
            leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu, color: kTextColor)),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search luxury furniture...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey)
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const HeroBanner(),
                  const SizedBox(height: 35),

                  const SectionHeader(title: "Collections"),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryData.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 20),
                      itemBuilder: (context, i) => _CategoryItem(
                          title: categoryData[i]['title']!,
                          img: categoryData[i]['img']!
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),
                  const SectionHeader(title: "New Arrivals"),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.60,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, i) => DarkProductCard(data: productData[i]),
                childCount: productData.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ).animate().fadeIn(duration: 800.ms),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22)),
        Text("See All", style: TextStyle(color: kGoldColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --- Dark Luxury Product Card (With AssetImage) ---
class DarkProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const DarkProductCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(data: data))),
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  Hero(
                    tag: data['img'],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        image: DecorationImage(
                            image: AssetImage(data['img']), // CHANGED TO ASSET IMAGE
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            // Details
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kTextColor), maxLines: 1),
                        const SizedBox(height: 4),
                        Text("Luxury Series", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kGoldColor)),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: Border.all(color: kGoldColor),
                              shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.add, color: kGoldColor, size: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }
}

// --- Category Item (With AssetImage) ---
class _CategoryItem extends StatelessWidget {
  final String title, img;
  const _CategoryItem({required this.title, required this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 75, height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage(img), // CHANGED TO ASSET IMAGE
                fit: BoxFit.cover
            ),
            border: Border.all(color: kCardColor, width: 2),
            boxShadow: [const BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 5))],
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 13, color: kTextColor)),
      ],
    );
  }
}

// --- Hero Banner (With AssetImage) ---
class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: const DecorationImage(
              // IMPORTANT: Make sure this file exists
              image: AssetImage("assets/images/banner.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
              begin: Alignment.bottomLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("LIMITED EDITION", style: TextStyle(color: kGoldColor, letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 10),
              Text("Midnight\nCollection", style: GoogleFonts.cinzel(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text("Shop Now", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
        ),
      ],
    ).animate().shimmer(duration: 2000.ms, color: kGoldColor.withOpacity(0.1));
  }
}

// --- Product Detail Screen (With AssetImage & Pixel Fix) ---
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProductDetailScreen({super.key, required this.data});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          Hero(
            tag: widget.data['img'],
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.data['img']), // CHANGED TO ASSET IMAGE
                    fit: BoxFit.cover
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kBgColor, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    )
                ),
              ),
            ),
          ),

          Positioned(
            top: 50, left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [kBgColor, Color(0xFF1A1A1A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.data['title'],
                          style: GoogleFonts.cinzel(fontSize: 26, color: kTextColor, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                          widget.data['price'],
                          style: GoogleFonts.lato(fontSize: 24, color: kGoldColor, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(Icons.star, color: kGoldColor, size: 20),
                      const SizedBox(width: 5),
                      Text("${widget.data['rating']} (128 verified reviews)", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  Text("Description", style: GoogleFonts.lato(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // FIXED SCROLLABLE TEXT
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        "Crafted from premium Italian materials, this piece embodies sophistication. Perfect for modern dark interiors, offering both comfort and a bold aesthetic statement. Designed to last a lifetime with memory foam cushions.",
                        style: TextStyle(color: Colors.grey[400], height: 1.6, fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(onTap: () => setState(() => quantity > 1 ? quantity-- : null), child: const Icon(Icons.remove, size: 20, color: Colors.white)),
                            const SizedBox(width: 15),
                            Text("$quantity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(width: 15),
                            GestureDetector(onTap: () => setState(() => quantity++), child: const Icon(Icons.add, size: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            cartService.add(CartItem(
                                title: widget.data['title'],
                                price: widget.data['price'],
                                img: widget.data['img'],
                                quantity: quantity
                            ));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: kGoldColor,
                              content: Text("Added to cart", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGoldColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ).animate().slideY(begin: 0.5, duration: 600.ms, curve: Curves.easeOutQuart),
          ),
        ],
      ),
    );
  }
}

// --- Cart Screen (With AssetImage) ---
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Selection", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: cartService.cartStream,
        initialData: cartService.items,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) return _buildEmptyState();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Dismissible(
                        key: Key(item.title),
                        onDismissed: (_) => cartService.remove(item),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: kCardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.05))
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage(item.img), // CHANGED TO ASSET IMAGE
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                                    const SizedBox(height: 5),
                                    Text(item.price, style: const TextStyle(color: kGoldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.grey), onPressed: () => cartService.decrement(item)),
                                  Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.white), onPressed: () => cartService.increment(item)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 110),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, -5))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 18, color: Colors.grey)),
                        Text("\$${cartService.getTotalPrice().toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kGoldColor)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGoldColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("CHECKOUT", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 1, duration: 500.ms),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.white12),
          const SizedBox(height: 20),
          Text("Your Cart is Empty", style: GoogleFonts.cinzel(fontSize: 20, color: Colors.grey)),
        ],
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collections"), backgroundColor: Colors.transparent),
      body: const Center(child: Text("Categories Coming Soon", style: TextStyle(color: Colors.grey))),
    );
  }
}

// --- Profile Screen (With AssetImage) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: kGoldColor),
              child: const CircleAvatar(
                  radius: 50,
                  // IMPORTANT: Make sure this file exists
                  backgroundImage: AssetImage("assets/images/profile.png")
              ),
            ),
            const SizedBox(height: 20),
            Text("Marcus Sterling", style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 5),
            Text("Elite Member", style: TextStyle(color: kGoldColor)),
            const SizedBox(height: 40),
            _profileItem(Icons.settings_outlined, "Settings"),
            _profileItem(Icons.credit_card_outlined, "Payment Methods"),
            _profileItem(Icons.bookmark_border, "Saved Items"),
          ],
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}