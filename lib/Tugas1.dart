import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShoppingCartPage(),
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int _selectedIndex = 2;

  bool showPopup = false;
  String popupProductName = '';

  List<Map<String, dynamic>> products = [
    {
      'name': 'Wireless Headphone',
      'brand': 'Sony WH-CH520',
      'price': 350000,
      'image': 'https://sony.scene7.com/is/image/sonyglobalsolutions/wh-ch520_Primary_image?&fmt=png-alpha',
      'likes': 12,
      'qty': 1,
      'isHighlighted': false,
      'isLiked': false,
    },
    {
      'name': 'Laptop ASUS Vivobook',
      'brand': 'ASUS',
      'price': 7500000,
      'image': 'assets/images/asus_vivobook_14_x1407qa_product_photo_1s_cool_silver_11_non-backlit.jpg',
      'likes': 8,
      'qty': 1,
      'isHighlighted': false,
      'isLiked': false,
    },
    {
      'name': 'Wireless Mouse',
      'brand': 'Logitech M330',
      'price': 250000,
      'image': 'https://down-id.img.susercontent.com/file/id-11134207-7r992-lwxpz7fl47xq0d',
      'likes': 5,
      'qty': 1,
      'isHighlighted': false,
      'isLiked': false,
    },
  ];

  int get totalPrice {
    int total = 0;
    for (var product in products) {
      if (product['isHighlighted'] == true) {
        total += (product['price'] as int) * (product['qty'] as int);
      }
    }
    return total;
  }

  int get totalSelectedItems {
    int count = 0;
    for (var product in products) {
      if (product['isHighlighted'] == true) {
        count++;
      }
    }
    return count;
  }

  String formatRupiah(int number) {
    String result = number.toString();
    String formatted = '';
    int count = 0;
    for (int i = result.length - 1; i >= 0; i--) {
      formatted = result[i] + formatted;
      count++;
      if (count == 3 && i != 0) {
        formatted = '.$formatted';
        count = 0;
      }
    }
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        leading: const Icon(Icons.shopping_cart, color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Belanja lebih mudah setiap hari', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    product['isHighlighted'] = !product['isHighlighted'];
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    product['likes'] += 1;
                    product['isLiked'] = true;
                  });
                },

                onLongPress: () {
                  setState(() {
                    showPopup = true;
                    popupProductName = product['name'];
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        showPopup = false;
                      });
                    }
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: product['isHighlighted'] ? const Color(0xFF1E88E5) : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 40, color: Colors.grey[400]);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(product['brand'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(formatRupiah(product['price']), style: const TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      product['isLiked'] ? Icons.favorite : Icons.favorite_border,
                                      color: product['isLiked'] ? Colors.red : Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('${product['likes']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildQtyButton(Icons.remove, () {
                                      if (product['qty'] > 1) {
                                        setState(() => product['qty'] -= 1);
                                      }
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('${product['qty']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    _buildQtyButton(Icons.add, () {
                                      setState(() => product['qty'] += 1);
                                    }),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            top: showPopup ? 16 : -150,
            left: 16,
            right: 16,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showPopup ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Produk dipilih!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('$popupProductName telah dipilih.', style: const TextStyle(fontSize: 12, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total ($totalSelectedItems produk)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(formatRupiah(totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E88E5))),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF1E88E5),
            unselectedItemColor: Colors.grey[400],
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              const BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kategori'),

              BottomNavigationBarItem(
                icon: Badge(
                  label: Text(
                    '$totalSelectedItems',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  isLabelVisible: totalSelectedItems > 0,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Keranjang',
              ),

              const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 16, color: const Color(0xFF1E88E5)),
      ),
    );
  }
}