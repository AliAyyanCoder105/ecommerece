import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ToyShopApp());
}

class ToyShopApp extends StatelessWidget {
  const ToyShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToyLand Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orangeAccent,
        brightness: Brightness.light,
      ),
      home: const ToyStoreHome(),
    );
  }
}

// Toy Model
class Toy {
  final String name;
  final String price;
  final String image;
  final String category;
  final double rating;
  bool isFavorite;

  Toy(this.name, this.price, this.image, this.category, this.rating, {this.isFavorite = false});
}

class ToyStoreHome extends StatefulWidget {
  const ToyStoreHome({super.key});

  @override
  State<ToyStoreHome> createState() => _ToyStoreHomeState();
}

class _ToyStoreHomeState extends State<ToyStoreHome> {
  int cartCount = 0;
  String selectedCategory = "All";

  final List<String> categories = ["All", "Action", "Educational", "Puzzle", "Cars"];

  final List<Toy> toys = [
    Toy("Robot Hero", "₹1,200", "🤖", "Action", 4.8),
    Toy("Dino Park", "₹850", "🦖", "Action", 4.5),
    Toy("Brainy Block", "₹500", "🧱", "Educational", 4.9),
    Toy("Super Car", "₹2,500", "🏎️", "Cars", 4.7),
    Toy("Magic Puzzle", "₹300", "🧩", "Puzzle", 4.2),
    Toy("Space Shuttle", "₹1,800", "🚀", "Action", 4.6),
    Toy("Teddy Bear", "₹700", "🧸", "Soft Toys", 4.9),
    Toy("Train Set", "₹3,200", "🚂", "Cars", 4.4),
  ];

  void addToCart() {
    HapticFeedback.lightImpact();
    setState(() {
      cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Toy added to cart! 🛒"),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Toy> filteredToys = selectedCategory == "All"
        ? toys
        : toys.where((t) => t.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.orangeAccent,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("ToyLand ✨", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: false,
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text("$cartCount", style: const TextStyle(fontSize: 10, color: Colors.white)),
                      ),
                    )
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),

          // Search & Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search toys...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedCategory == categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(categories[index]),
                            selected: isSelected,
                            onSelected: (val) => setState(() => selectedCategory = categories[index]),
                            selectedColor: Colors.orangeAccent,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Popular Toys", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final toy = filteredToys[index];
                  return _buildToyCard(toy);
                },
                childCount: filteredToys.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToyCard(Toy toy) {
    return GestureDetector(
      onTap: () => _showProductDetails(toy),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(child: Text(toy.image, style: const TextStyle(fontSize: 60))),
              ),
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(toy.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      Text(" ${toy.rating}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(toy.price, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.orangeAccent, fontSize: 16)),
                      GestureDetector(
                        onTap: addToCart,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showProductDetails(Toy toy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(toy.image, style: const TextStyle(fontSize: 100))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(toy.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Text(toy.price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              ],
            ),
            Text(toy.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              "Duniya ka behtareen toy jo aapke bache ki creativity ko boost karega. Isme koi harmful chemicals nahi hain aur ye bilkul safe hai.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  addToCart();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Add to Shopping Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}