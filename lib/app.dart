import 'package:flutter/material.dart';

// --- الشاشة الرئيسية للتحكم في التنقل بين واجهات الزبون الستة ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentScreenIndex = 0; // البداية من شاشة الترحيب

  void _navigateTo(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // قائمة الشاشات الستة المرتبة حسب دورة حياة طلب الزبون
    final List<Widget> screens = [
      WelcomeScreen(onStart: () => _navigateTo(1)),               // 0: شاشة البداية
      HomeScreen(onSelectRestaurant: () => _navigateTo(2)),        // 1: الصفحة الرئيسية
      RestaurantsListScreen(onSelectMeal: () => _navigateTo(3)),  // 2: قائمة المطاعم
      MealDetailsScreen(onGoToCart: () => _navigateTo(4)),        // 3: تفاصيل المطعم والوجبة
      CartScreen(onCheckout: () => _navigateTo(5)),               // 4: السلة والدفع
      TrackingScreen(onBackToHome: () => _navigateTo(1)),         // 5: متابعة الطلب والتتبع
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: screens[_currentScreenIndex],
        // شريط التنقل السفلي يظهر فقط في الشاشات الداخلية (الرئيسية، القائمة، السلة، التتبع)
        bottomNavigationBar: _currentScreenIndex == 0 
            ? null 
            : BottomNavigationBar(
                currentIndex: _currentScreenIndex == 1 ? 4 : (_currentScreenIndex == 4 ? 2 : 4),
                onTap: (index) {
                  if (index == 4) _navigateTo(1); // العودة للرئيسية
                  if (index == 2) _navigateTo(4); // الذهاب للسلة
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF0F172A),
                selectedItemColor: const Color(0xFF1AD1FF),
                unselectedItemColor: Colors.grey.shade600,
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

// ==========================================
// 1. شاشة البداية (Welcome Screen)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;
  const WelcomeScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية معتمة تبرز شعار التطبيق
          Container(color: const Color(0xFF070B18)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FLOW',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF1AD1FF), italic: true, letterSpacing: 2),
                ),
                const SizedBox(height: 10),
                Text('فلو... طلبك يمشي بسلاسة.', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                const SizedBox(height: 100),
                // زر ابدأ الآن النيون المشع
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      shadowColor: const Color(0xFF007AFF).withOpacity(0.5),
                      elevation: 10,
                    ),
                    onPressed: onStart,
                    child: const Text('إبدأ الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('لديك حساب؟ ', style: TextStyle(color: Colors.grey.shade500)),
                    const Text('تسجيل الدخول', style: TextStyle(color: Color(0xFF1AD1FF), fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 2. الصفحة الرئيسية (Home Screen)
// ==========================================
class HomeScreen extends StatelessWidget {
  final VoidCallback onSelectRestaurant;
  const HomeScreen({super.key, required this.onSelectRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.location_on, color: Color(0xFFFF9500)),
            SizedBox(width: 6),
            Text('النجف الأشرف', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط البحث المخصص بالتصميم
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'ابحث عن مطعم، متجر أو منتج...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // بانر العرض العلوي المكتوب فيه "أطلب من مطعمك المفضل"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أطلب من مطعمك
المفضل المختار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007AFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    onPressed: onSelectRestaurant,
                    child: const Text('أطلب الآن', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            // شريط الأقسام الخماسية (تكسي، هدايا واكسسوارات، صيدليات، متاجر، مطاعم)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(Icons.electric_car, 'تكسي'),
                _buildCategoryIcon(Icons.card_giftcard, 'هدايا'),
                _buildCategoryIcon(Icons.local_pharmacy, 'صيدليات'),
                _buildCategoryIcon(Icons.store, 'متاجر'),
                _buildCategoryIcon(Icons.restaurant, 'مطاعم', isSelected: true),
              ],
            ),
            const SizedBox(height: 24),
            const Text('أقرب المطاعم المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            // بطاقات المطاعم المقترحة
            GestureDetector(
              onTap: onSelectRestaurant,
              child: _buildRestaurantItem('مطعم بيتزا هت', '30 دقيقة', '4.6'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF1E293B),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF1AD1FF), size: 26),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildRestaurantItem(String name, String time, String rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.restaurant, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 14, color: Color(0xFFFF9500)),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
        ],
      ),
    );
  }
}

// ==========================================
// 3. شاشة قائمة المطاعم (Restaurants List Screen)
// ==========================================
class RestaurantsListScreen extends StatelessWidget {
  final VoidCallback onSelectMeal;
  const RestaurantsListScreen({super.key, required this.onSelectMeal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المطاعم'), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // شريط الفلاتر العلوي (الأكثر طلباً، التقييم الأعلى)
          Row(
            children: [
              _buildFilterBadge('الأكثر طلباً', isSelected: true),
              const SizedBox(width: 8),
              _buildFilterBadge('التقييم الأعلى'),
              const SizedBox(width: 8),
              _buildFilterBadge('الأقرب جغرافياً'),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onSelectMeal,
            child: _buildVerticalRestaurantCard('مطعم بيتزا هت', '30 دقيقة', 'مفتوح', '4.6'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onSelectMeal,
            child: _buildVerticalRestaurantCard('مطعم برجر كنج', '25 دقيقة', 'مفتوح', '4.5'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBadge(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey)),
    );
  }

  Widget _buildVerticalRestaurantCard(String name, String time, String status, String rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(width: 70, height: 70, decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.fastfood, color: Colors.grey)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text('$time  •  $status', style: const TextStyle(color: Color(0xFF1AD1FF), fontSize: 13)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFF9500), size: 16),
              const SizedBox(width: 4),
              Text(rating),
            ],
          )
        ],
      ),
    );
  }
}

// ==========================================
// 4. شاشة تفاصيل المطعم والوجبة (Meal Details)
// ==========================================
class MealDetailsScreen extends StatelessWidget {
  final VoidCallback onGoToCart;
  const MealDetailsScreen({super.key, required this.onGoToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // صورة الوجبة العلوية الكبيرة المطبقة في الواجهة الرابعة
          Container(
            height: 260,
            width: double.infinity,
            color: const Color(0xFF1E293B),
            child: const Icon(Icons.local_pizza, size: 100, color: Colors.grey),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('مطعم بيتزا هت', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Color(0xFFFF9500), size: 18),
                      SizedBox(width: 4),
                      Text('4.6 (3.2k تقييم)', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('أكثر طلباً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1AD1FF))),
                  const SizedBox(height: 12),
                  // صنف وجبة مع زر إضافة للسلة المباشر بقيمة 18,000 د.ع
                  _buildMealSelectionRow('بيتزا مارجريتا', '8,000 د.ع'),
                  _buildMealSelectionRow('بيتزا دجاج', '10,000 د.ع'),
                  const Spacer(),
                  // شريط الدفع السفلي الإجمالي والشراء
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007AFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      onPressed: onGoToCart,
                      icon: const Icon(Icons.shopping_basket, color: Colors.white),
                      label: const Text('عرض السلة (18,000 د.ع)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMealSelectionRow(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(price, style: const TextStyle(color: Colors.grey, fontSize: 13))]),
          IconButton(icon: const Icon(Icons.add_circle, color: Color(0xFF1AD1FF), size: 28), onPressed: () {})
        ],
      ),
    );
  }
}

// ==========================================
// 5. شاشة السلة والدفع (Cart Screen)
// ==========================================
class CartScreen extends StatelessWidget {
  final VoidCallback onCheckout;
  const CartScreen({super.key, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السلة'), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCartItem('بيتزا مارجريتا', '8,000 د.ع', '1'),
            _buildCartItem('كوكاكولا', '2,000 د.ع', '1'),
            const Spacer(),
            const Divider(color: Colors.white12),
            _buildSummaryRow('إجمالي الطلب:', '10,000 د.ع'),
            _buildSummaryRow('رسوم التوصيل:', '2,000 د.ع'),
            _buildSummaryRow('المجموع الكلي:', '12,000 د.ع', isTotal: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007AFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: onCheckout,
                child: const Text('إتمام الطلب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String price, String qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(price, style: const TextStyle(color: Color(0xFF1AD1FF)))]),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.grey), onPressed: () {}),
              Text(qty, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1AD1FF)), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : Alignment.centerRight as FontWeight?)),
          Text(val, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.bold, color: isTotal ? const Color(0xFFFF9500) : Colors.white)),
        ],
      ),
    );
  }
}

// ==========================================
// 6. شاشة متابعة الطلب والتتبع (Tracking Screen)
// ==========================================
class TrackingScreen extends StatelessWidget {
  final VoidCallback onBackToHome;
  const TrackingScreen({super.key, required this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // مساحة محاكاة الخريطة الحية للتتبع الجغرافي
          Container(
            color: const Color(0xFF1E293B),
            child: const Center(child: Icon(Icons.map, size: 80, color: Colors.white24)),
          ),
          // تفاصيل السائق الحالي أسفل الشاشة المفتوحة بالتصميم
          Positioned(
            bottom: 0, right: 0, left: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('جاري التوصيل...', style: TextStyle(fontSize: 15, color: Color(0xFF1AD1FF))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(radius: 26, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('أحمد علي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text('سيارة تيسلا - النجف #1234', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.phone, color: Color(0xFF10B981)), onPressed: () {})
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('الوصول خلال 12 دقيقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF9500))),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF1AD1FF)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: onBackToHome,
                      child: const Text('العودة للرئيسية', style: TextStyle(color: Color(0xFF1AD1FF))),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}