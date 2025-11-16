import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const DreamLifeApp());
}
class DreamLifeApp extends StatelessWidget {
  const DreamLifeApp({super.key});
//vuvuticvtcvk
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dream Life",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xfff5f7fa),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),

      home: const MainNavigation(),
    );
  }
}


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final screens = [
    DiscoverScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index]
          .animate()
          .fade(duration: 350.ms)
          .slide(begin: const Offset(0.05, 0.03), duration: 300.ms),

      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.dashboard_customize_outlined),
              label: "Categories"),
          NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}


class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({super.key});

  final categoryData = [
    {"title": "Sofas", "img": "assets/images/sofa1.png"},
    {"title": "Tables", "img": "assets/images/table1.png"},
    {"title": "Chairs", "img": "assets/images/chair1.png"},
  ];

  final productData = [
    {
      "title": "Luxury Grey Sofa",
      "price": "\$299",
      "rating": 4.8,
      "img": "assets/images/sofa1.png"
    },
    {
      "title": "Classic Comfort Sofa",
      "price": "\$199",
      "rating": 4.5,
      "img": "assets/images/sofa2.png"
    },
    {
      "title": "Royal Premium Sofa",
      "price": "\$399",
      "rating": 4.9,
      "img": "assets/images/sofa3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Discover",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black))
                .animate()
                .fade()
                .moveY(begin: -10, duration: 400.ms),

            const SizedBox(height: 18),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search products",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ).animate().fade(duration: 300.ms),

            const SizedBox(height: 25),

            _sectionTitle("Categories"),

            const SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryData.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final c = categoryData[i];
                  return _categoryCard(c["title"]!, c["img"]!);
                },
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle("Most Popular"),

            const SizedBox(height: 12),

        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: productData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final p = productData[i];
              return ProductCard(
                title: p["title"].toString(),
                price: p["price"].toString(),
                rating: double.parse(p["rating"].toString()),
                img: p["img"].toString(),
              );

            },
          ),
        ),

        ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _categoryCard(String name, String img) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, height: 60).animate().fade().scale(),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    ).animate().fade().moveX(begin: 30);
  }
}

// -----------------------------------------------------
// PRODUCT CARD
// -----------------------------------------------------
class ProductCard extends StatelessWidget {
  final String title, price, img;
  final double rating;

  const ProductCard(
      {super.key,
        required this.title,
        required this.price,
        required this.rating,
        required this.img});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  title: title,
                  price: price,
                  img: img,
                  rating: rating,
                )));
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                    image: AssetImage(img), fit: BoxFit.cover),
              ),
            ).animate().fade().scale(),

            const SizedBox(height: 10),

            Text(title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),

            Text(price,
                style: const TextStyle(
                    fontSize: 14, color: Colors.grey)),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade().moveX(begin: 40);
  }
}

// -----------------------------------------------------
// PRODUCT DETAIL SCREEN (PREMIUM)
// -----------------------------------------------------
class ProductDetailScreen extends StatelessWidget {
  final String title, price, img;
  final double rating;

  const ProductDetailScreen(
      {super.key,
        required this.title,
        required this.price,
        required this.img,
        required this.rating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // IMAGE TOP SECTION
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: img,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(img), fit: BoxFit.cover),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                )
              ],
            ),
          ),

          // DETAILS SECTION
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 20, color: Colors.amber),
                    Text("$rating  |  245 reviews",
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Experience ultimate comfort with this premium handmade sofa designed with high-grade materials and soft cushions.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      onPressed: () {},
                      child: const Text("Add to Cart",
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// OTHER SCREENS
// -----------------------------------------------------
class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final categories = ["Sofas", "Tables", "Chairs", "Beds", "Lights"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(categories[i],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          ).animate().fade().moveX(begin: 40);
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Your Cart is Empty", style: TextStyle(fontSize: 18)),
    ).animate().fade().scale();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("User Profile", style: TextStyle(fontSize: 18)),
    ).animate().fade().scale();
  }
}
