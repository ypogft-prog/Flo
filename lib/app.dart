import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 4; // الافتراضي هو الصفحة الرئيسية من اليمين

  final List<Widget> _screens = [
    const Center(child: Text('شاشة الحساب الشخصي', style: TextStyle(fontSize: 24))),
    const Center(child: Text('شاشة المحفظة والأرباح', style: TextStyle(fontSize: 24))),
    const Center(child: Text('شاشة الطلبات والتتبع', style: TextStyle(fontSize: 24))),
    const Center(child: Text('شاشة العروض والخصومات', style: TextStyle(fontSize: 24))),
    const HomeScreen(), // الصفحة الرئيسية المطلوبة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF111827),
          selectedItemColor: const Color(0xFF1AD1FF), // أزرق نيون مشع عند الاختيار
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الحساب'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'المحفظة'),
            BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'الطلبات'),
            BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'العروض'),
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
          ],
        ),
      ),
    );
  }
}

// بناء الصفحة الرئيسية بالكامل
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFFFF9500)),
            const SizedBox(width: 8),
            Text('النجف الأشرف', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط البحث المخصص
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'ابحث عن مطعم، متجر أو منج...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // عنوان الأقسام الرئيسية الـ 5
            const Text(
              'أطلب من مطعمك المفضل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // قائمة الأقسام العلوية الدائرية (مشاوير، مستلزمات، صيدليات، متاجر، مطاعم)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryItem(Icons.directions_car, 'مشاوير'),
                _buildCategoryItem(Icons.shopping_bag, 'مستلزمات'),
                _buildCategoryItem(Icons.local_pharmacy, 'صيدليات'),
                _buildCategoryItem(Icons.store, 'متاجر'),
                _buildCategoryItem(Icons.restaurant, 'مطاعم', isSelected: true),
              ],
            ),
            const SizedBox(height: 28),

            // عنوان قائمة المطاعم المتاحة
            const Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text('أقرب المطاعم المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('عرض الكل', style: TextStyle(color: Color(0xFF1AD1FF), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),

            // قائمة المطاعم الذكية (ListView)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                List<Map<String, dynamic>> dummyRestaurants = [
                  {'name': 'مطعم بيتزا هت', 'time': '30 دقيقة', 'rating': '4.6'},
                  {'name': 'مطعم برجر كنج', 'time': '25 دقيقة', 'rating': '4.5'},
                  {'name': 'مطعم كباب التاج', 'time': '40 دقيقة', 'rating': '4.8'},
                ];
                return _buildRestaurantCard(
                  dummyRestaurants[index]['name'],
                  dummyRestaurants[index]['time'],
                  dummyRestaurants[index]['rating'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ودجت بناء أيقونة القسم الدائرية
  Widget _buildCategoryItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF1F2937),
            shape: BoxShape.circle,
            boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF007AFF).withOpacity(0.4), blurRadius: 10)] : [],
          ),
          child: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF1AD1FF), size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey[400])),
      ],
    );
  }

  // ودجت بطاقات عرض المطاعم المتاحة
  Widget _buildRestaurantCard(String name, String time, String rating) {
    return Container(
      margin: const EdgeInsets.bottom(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey, size: 35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(Icons.star, size: 14, color: Color(0xFFFF9500)),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('مفتوح', style: TextStyle(color: Color(0xFF10B981), fontSize: 11)),
          )
        ],
      ),
    );
  }
}
