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
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.orangeAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        cardColor: const Color(0xFF1C1C1E),
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

  Toy(this.name, this.price, this.image, this.category, this.rating);
}

class ToyStoreHome extends StatefulWidget {
  const ToyStoreHome({super.key});

  @override
  State<ToyStoreHome> createState() => _ToyStoreHomeState();
}

class _ToyStoreHomeState extends State<ToyStoreHome> with SingleTickerProviderStateMixin {
  String selectedCategory = "All";
  List<Toy> cartItems = [];

  final List<String> categories = ["All", "Action", "Educational", "Puzzle", "Cars"];

  final List<Toy> toys = [
    Toy("Robot Hero", "1200", "🤖", "Action", 4.8),
    Toy("Dino Park", "850", "🦖", "Action", 4.5),
    Toy("Brainy Block", "500", "🧱", "Educational", 4.9),
    Toy("Super Car", "2500", "🏎️", "Cars", 4.7),
    Toy("Magic Puzzle", "300", "🧩", "Puzzle", 4.2),
    Toy("Space Shuttle", "1800", "🚀", "Action", 4.6),
  ];

  late AnimationController _cartPulseController;

  @override
  void initState() {
    super.initState();
    _cartPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
  }

  @override
  void dispose() {
    _cartPulseController.dispose();
    super.dispose();
  }

  void addToCart(Toy toy) {
    HapticFeedback.lightImpact();
    setState(() {
      cartItems.add(toy);
    });
    _cartPulseController.forward(from: 0.9);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${toy.name} added to cart 🛒"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == "All"
        ? toys
        : toys.where((t) => t.category == selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black,
            title: const Text("ToyLand ✨"),
            actions: [
              ScaleTransition(
                scale: _cartPulseController,
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CartScreen(cartItems: cartItems),
                          ),
                        );
                      },
                    ),
                    if (cartItems.isNotEmpty)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.orangeAccent,
                          child: Text(
                            "${cartItems.length}",
                            style: const TextStyle(fontSize: 11, color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          // Search & Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search toys...",
                      filled: true,
                      fillColor: const Color(0xFF1C1C1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (_, i) {
                        final selected = categories[i] == selectedCategory;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(categories[i]),
                            selected: selected,
                            selectedColor: Colors.orangeAccent,
                            backgroundColor: Colors.grey[850],
                            labelStyle: TextStyle(
                              color: selected ? Colors.black : Colors.white,
                            ),
                            onSelected: (_) =>
                                setState(() => selectedCategory = categories[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _toyCard(filtered[index]),
                childCount: filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toyCard(Toy toy) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => ToyDetailScreen(
              toy: toy,
              onAdd: () => addToCart(toy),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.orangeAccent.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Hero(
              tag: toy.name,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(toy.image, style: const TextStyle(fontSize: 42)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(toy.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 14, color: Colors.orangeAccent),
                Text(" ${toy.rating}", style: const TextStyle(fontSize: 12)),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${toy.price}",
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () => addToCart(toy),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== Detail Screen ======
class ToyDetailScreen extends StatelessWidget {
  final Toy toy;
  final Function onAdd;

  const ToyDetailScreen({super.key, required this.toy, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: toy.name,
              child: Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent.withOpacity(0.15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.3),
                        blurRadius: 30,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(toy.image, style: const TextStyle(fontSize: 80)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(toy.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(toy.category, style: TextStyle(color: Colors.grey.shade400)),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orangeAccent),
                Text(" ${toy.rating} rating"),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              "This premium quality toy boosts creativity, imagination, and joy. "
                  "Made with child-safe materials and designed for endless fun.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  onAdd();
                  Navigator.pop(context);
                },
                child: Text(
                  "Add to Cart • ₹${toy.price}",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== Cart Screen ======
class CartScreen extends StatelessWidget {
  final List<Toy> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(
      0,
          (sum, item) => sum + double.parse(item.price),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cartItems.isEmpty
          ? const Center(
        child: Text(
          "Your cart is empty 🛒",
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final toy = cartItems[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                    child: Text(toy.image),
                  ),
                  title: Text(toy.name),
                  subtitle: Text("₹${toy.price}"),
                  trailing: const Icon(Icons.check_circle, color: Colors.orangeAccent),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total", style: TextStyle(fontSize: 18)),
                    Text(
                      "₹$total",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {},
                    child: const Text("Checkout", style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
