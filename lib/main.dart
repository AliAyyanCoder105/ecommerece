import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

// To use Google Fonts and Animate, add to your pubspec.yaml:
// dependencies:
//   google_fonts: ^6.1.0
//   flutter_animate: ^4.5.0

void main() {
  runApp(const DreamLifeApp());
}

class DreamLifeApp extends StatelessWidget {
  const DreamLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dream Life",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xfff5f7fa),
        useMaterial3: true,
        primaryColor: const Color(0xff4a69ff),
        textTheme: GoogleFonts.interTextTheme(textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff4a69ff),
          brightness: Brightness.light,
          primary: const Color(0xff4a69ff),
          secondary: const Color(0xfff2994a),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff121212),
        useMaterial3: true,
        primaryColor: const Color(0xff5C7BFF),
        textTheme: GoogleFonts.interTextTheme(textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff5C7BFF),
          brightness: Brightness.dark,
          primary: const Color(0xff5C7BFF),
          secondary: const Color(0xfff2c94c),
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

  static final List<Widget> _screens = <Widget>[
    DiscoverScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: "Categories"),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: "Cart"),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// --- Discover Screen: Conqueror Level ---
class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({super.key});

  final categoryData = [
    {"title": "Sofas", "img": "assets/images/sofa1.png"},
    {"title": "Tables", "img": "assets/images/table1.png"},
    {"title": "Chairs", "img": "assets/images/chair1.png"},
    {"title": "Beds", "img": "assets/images/sofa2.png"},
  ];

  final productData = [
    {"title": "Luxury Grey Sofa", "price": "\$299", "rating": 4.8, "img": "assets/images/sofa1.png"},
    {"title": "Classic Comfort Sofa", "price": "\$199", "rating": 4.5, "img": "assets/images/sofa2.png"},
    {"title": "Royal Premium Sofa", "price": "\$399", "rating": 4.9, "img": "assets/images/sofa3.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("DREAM LIFE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            centerTitle: true,
            floating: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded))
            ],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(isDark).animate().fade().slideY(begin: 0.2, delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 25),
                  const FeaturedBannerCarousel(),
                  const SizedBox(height: 25),
                  _buildSectionTitle("Categories", () {}),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryData.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, i) {
                        final c = categoryData[i];
                        return _categoryCard(context, c["title"]!, c["img"]!);
                      },
                    )
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle("Most Popular", () {}),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, i) {
                  final p = productData[i];
                  return ProductCard(
                    title: p["title"].toString(),
                    price: p["price"].toString(),
                    rating: double.parse(p["rating"].toString()),
                    img: p["img"].toString(),
                  );
                },
                childCount: productData.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildSectionTitle(String text, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onTap, child: const Text("See All")),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const TextField(
        decoration: InputDecoration(hintText: "Search furniture...", border: InputBorder.none, icon: Icon(Icons.search)),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, String name, String img) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, height: 45),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// --- Featured Banner Carousel ---
class FeaturedBannerCarousel extends StatefulWidget {
  const FeaturedBannerCarousel({super.key});
  @override
  State<FeaturedBannerCarousel> createState() => _FeaturedBannerCarouselState();
}
class _FeaturedBannerCarouselState extends State<FeaturedBannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: _currentPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(5.seconds, (timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(_currentPage, duration: 400.ms, curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _buildFeaturedBanner(context, "New Collection", "30% Off All Sofas", "assets/images/sofa3.png", Theme.of(context).colorScheme.primary),
              _buildFeaturedBanner(context, "Clearance Sale", "Up to 50% Off", "assets/images/chair1.png", Theme.of(context).colorScheme.secondary),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return AnimatedContainer(
              duration: 200.ms,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    ).animate().fade(delay: 200.ms).slideX(begin: -0.2, duration: 400.ms);
  }

  Widget _buildFeaturedBanner(BuildContext context, String subtitle, String title, String imagePath, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Image.asset(imagePath, height: 100, fit: BoxFit.contain)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -5, end: 5, duration: 2000.ms, curve: Curves.easeInOut)
        ],
      ),
    );
  }
}

// --- Product Card ---
class ProductCard extends StatelessWidget {
  final String title, price, img;
  final double rating;

  const ProductCard({super.key, required this.title, required this.price, required this.rating, required this.img});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(title: title, price: price, img: img, rating: rating)));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: img,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.asset(img, fit: BoxFit.cover, width: double.infinity),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      radius: 15,
                      child: Icon(Icons.favorite_border, size: 18, color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16), Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold))]),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(delay: 500.ms).slideY(begin: 0.5);
  }
}

// --- Product Detail Screen ---
class ProductDetailScreen extends StatefulWidget {
  final String title, price, img;
  final double rating;
  const ProductDetailScreen({super.key, required this.title, required this.price, required this.img, required this.rating});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedColorIndex = 0;
  final List<Color> _colors = [const Color(0xff7C7C7C), const Color(0xffC0A793), const Color(0xff2B3A55)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.img,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Image.asset(widget.img, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)).animate().fade(delay: 200.ms).slideX(),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.star, size: 20, color: Colors.amber), Text(" ${widget.rating}  |  245 reviews", style: const TextStyle(color: Colors.grey, fontSize: 14))]).animate().fade(delay: 300.ms).slideX(),
                  const SizedBox(height: 20),
                  const Text("Experience ultimate comfort with this premium handmade sofa designed with high-grade materials and soft cushions.", style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5)).animate().fade(delay: 400.ms).slideX(),
                  const SizedBox(height: 25),
                  const Text("Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(_colors.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColorIndex = index),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          margin: const EdgeInsets.only(right: 10),
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: _colors[index],
                            shape: BoxShape.circle,
                            border: _selectedColorIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 3) : null,
                          ),
                        ),
                      );
                    }).animate(interval: 100.ms).fade(delay: 500.ms).slideY(begin: 0.5),
                  ),
                  const SizedBox(height: 25),
                  const Text("Quantity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _quantityButton(Icons.remove, () {
                        if (_quantity > 1) setState(() => _quantity--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(_quantity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      _quantityButton(Icons.add, () => setState(() => _quantity++)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 35, height: 35,
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Price", style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text(widget.price, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Cart!"), backgroundColor: Colors.green));
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text("Add to Cart", style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 1, duration: 400.ms);
  }
}

// --- Placeholder Screens with "Conqueror" UI ---
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Center(child: Text("Categories Screen Content", style: Theme.of(context).textTheme.headlineSmall)),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text("Your Cart is Empty", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Looks like you haven't added\nanything to your cart yet.", style: TextStyle(color: Colors.grey.shade600, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {}, // Navigate to Discover Screen
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text("Start Shopping"),
            ),
          ],
        ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 10),
          const Text("John Doe", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("john.doe@email.com", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          _buildProfileTile(context, Icons.list_alt_rounded, "My Orders"),
          _buildProfileTile(context, Icons.location_on_outlined, "Shipping Addresses"),
          _buildProfileTile(context, Icons.payment_rounded, "Payment Methods"),
          _buildProfileTile(context, Icons.logout, "Log Out", isLogout: true),
        ].animate(interval: 100.ms).fade(delay: 200.ms).slideX(begin: 0.5),
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context, IconData icon, String title, {bool isLogout = false}) {
    final color = isLogout ? Colors.redAccent : Theme.of(context).textTheme.bodyLarge?.color;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}