import 'package:flutter/material.dart';

// ==========================================
// شاشة التحكم الرئيسية وإدارة التنقل بين واجهات الزبون الستة
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentScreenIndex = 0;

  void _navigateTo(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      WelcomeScreen(onStart: () => _navigateTo(1)),
      HomeScreen(onSelectRestaurant: () => _navigateTo(2)),
      RestaurantsListScreen(onSelectMeal: () => _navigateTo(3)),
      MealDetailsScreen(onGoToCart: () => _navigateTo(4)),
      CartScreen(onCheckout: () => _navigateTo(5)),
      TrackingScreen(onBackToHome: () => _navigateTo(1)),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: screens[_currentScreenIndex],
        bottomNavigationBar: _currentScreenIndex == 0 || _currentScreenIndex == 5
            ? null
            : BottomNavigationBar(
                currentIndex: _currentScreenIndex == 1
                    ? 0
                    : _currentScreenIndex == 2
                        ? 1
                        : _currentScreenIndex == 3
                            ? 2
                            : _currentScreenIndex == 4
                                ? 3
                                : 0,
                onTap: (index) {
                  if (index == 0) _navigateTo(1);
                  if (index == 1) _navigateTo(2);
                  if (index == 2) _navigateTo(3);
                  if (index == 3) _navigateTo(4);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1E293B),
                selectedItemColor: const Color(0xFF007AFF),
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.restaurant),
                    label: 'المطاعم',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fastfood),
                    label: 'تفاصيل الوجبة',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_basket),
                    label: 'السلة',
                  ),
                ],
              ),
      ),
    );
  }
}

// ==========================================
// 1. شاشة البداية (Welcome Screen) المحدثة والمطابقة للتصميم
// ==========================================
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;
  const WelcomeScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية داكنة مع تدرج لوني خفيف من الأعلى للأسفل
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF090D16),
                ],
              ],
            ),
          ),
          
          // 2. صورة معالم النجف الأشرف المدمجة في أسفل النصف العلوي
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.35, // مدمجة مع الخلفية الداكنة بشكل متناسق
              child: Image.network(
                'https://images.unsplash.com/photo-1590075865003-e48277afd558?q=80&w=600&auto=format&fit=crop',
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // رسم معالم بديلة هندسية في حال عدم توفر اتصال بالإنترنت للأصول الخارجية
                  return SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (index) => Container(
                        width: 30,
                        height: 60.0 + (index * 25),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. المحتوى والنصوص والشعارات مرتبة عمودياً بصورة مطابقة للـ UI المطلوبة
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 40),
                  
                  // مجموعة الشعار والاسم والوصف
                  Column(
                    children: [
                      // رسم الشعار المخصص (لوغو حرف F الانسيابي مع النقطة الصفراء) باستخدام CustomPaint
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CustomPaint(
                          painter: FlowLogoPainter(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // كلمة FLOW بخط مائل عريض ولون أبيض
                      const Text(
                        'FLOW',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // جملة الوصف مع تلوين كلمة فلو بالأزرق السماوي
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, fontFamily: 'Tahoma'),
                          children: [
                            TextSpan(
                              text: 'فلو',
                              style: TextStyle(
                                color: Color(0xFF00C6FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '... طلبك يمشي بسلاسة.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // مجموعة أزرار التحكم بالأسفل
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                    child: Column(
                      children: [
                        // زر ابدأ الآن الأزرق العريض الممتد بحواف دائرية ناعمة
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007AFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 4,
                            ),
                            onPressed: onStart,
                            child: const Text(
                              'ابدأ الآن',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // نص تسجيل الدخول السفلي الملون
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب؟ ',
                              style: TextStyle(color: Colors.white60, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: Color(0xFF00C6FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

// رسم شعار تطبيق FLOW المخصص لحرف الفاء الانسيابي مع النقطة المائلة
class FlowLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()
      ..color = const Color(0xFF007AFF)
      ..style = PaintingStyle.fill;

    final paintSky = Paint()
      ..color = const Color(0xFF00C6FF)
      ..style = PaintingStyle.fill;

    final paintYellow = Paint()
      ..color = const Color(0xFFFFCC00)
      ..style = PaintingStyle.fill;

    // 1. رسم الجناح العلوي الكبير لحرف F
    final pathTop = Path()
      ..moveTo(size.width * 0.25, size.height * 0.25)
      ..cubicTo(size.width * 0.5, size.height * 0.15, size.width * 0.85, size.height * 0.15, size.width * 0.95, size.height * 0.18)
      ..cubicTo(size.width * 0.85, size.height * 0.35, size.width * 0.6, size.height * 0.4, size.width * 0.45, size.height * 0.42)
      ..close();
    canvas.drawPath(pathTop, paintBlue);

    // 2. رسم الساق السفلية المائلة والمنحنية للانسيابية
    final pathBottom = Path()
      ..moveTo(size.width * 0.45, size.height * 0.42)
      ..cubicTo(size.width * 0.35, size.height * 0.55, size.width * 0.3, size.height * 0.75, size.width * 0.35, size.height * 0.85)
      ..cubicTo(size.width * 0.42, size.height * 0.75, size.width * 0.5, size.height * 0.55, size.width * 0.58, size.height * 0.43)
      ..close();
    canvas.drawPath(pathBottom, paintSky);

    // 3. رسم النقطة الجانبية المائلة المميزة باللون الأصفر
    final pathDot = Path()
      ..moveTo(size.width * 0.12, size.height * 0.48)
      ..lineTo(size.width * 0.25, size.height * 0.40)
      ..lineTo(size.width * 0.30, size.height * 0.48)
      ..lineTo(size.width * 0.17, size.height * 0.56)
      ..close();
    canvas.drawPath(pathDot, paintYellow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF007AFF)),
            SizedBox(width: 6),
            Text(
              'النجف الأشرف',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'ابحث عن مطعم أو منتج',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007AFF), Color(0xFF00C6FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'خصم يصل إلى 50%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'اطلب الآن',
                      style: TextStyle(color: Color(0xFF007AFF)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryIcon(Icons.fastfood, 'وجبات', true),
                _buildCategoryIcon(Icons.local_pizza, 'بيتزا', false),
                _buildCategoryIcon(Icons.cake, 'حلويات', false),
                _buildCategoryIcon(Icons.local_cafe, 'قهوة', false),
                _buildCategoryIcon(Icons.icecream, 'مأكولات', false),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'المطاعم المتاحة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onSelectRestaurant,
              child: _buildRestaurantItem('مطعم بيتزا هت', '30 دقيقة', '4.6'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, bool isSelected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF0F172A),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRestaurantItem(String name, String time, String rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: Colors.grey, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 14, color: Color(0xFFFF9500)),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        title: const Text('المطاعم', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            child: _buildVerticalRestaurantCard(
              'مطعم بيتزا هت',
              '30 دقيقة',
              'مفتوح',
              '4.6',
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onSelectMeal,
            child: _buildVerticalRestaurantCard(
              'مطعم برجر كنج',
              '25 دقيقة',
              'مفتوح',
              '4.5',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBadge(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF007AFF) : Colors.grey,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildVerticalRestaurantCard(
      String name, String time, String status, String rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$time • $status',
                  style: const TextStyle(
                    color: Color(0xFF1AD1FF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFF9500), size: 16),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(color: Colors.white)),
            ],
          ),
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
      backgroundColor: const Color(0xFF1E293B),
      body: Column(
        children: [
          Container(
            height: 260,
            width: double.infinity,
            color: const Color(0xFF1E293B),
            child: const Center(
              child: Icon(
                Icons.local_pizza,
                size: 100,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مطعم بيتزا هت',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFF9500), size: 18),
                      SizedBox(width: 4),
                      Text(
                        '4.6 (3.2k تقييم)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'الأكثر طلباً',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1AD1FF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMealSelectionRow('بيتزا مارجريتا', '8,000 د.ع.'),
                  _buildMealSelectionRow('بيتزا دجاج', '10,000 د.ع.'),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onGoToCart,
                      icon: const Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'عرض السلة (18,000 د.ع.)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget _buildMealSelectionRow(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                price,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            color: const Color(0xFF1AD1FF),
            iconSize: 28,
            onPressed: () {},
          ),
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
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        title: const Text('السلة', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCartItem('بيتزا مارجريتا', '8,000 د.ع.', '1'),
            _buildCartItem('كوكاكولا', '2,000 د.ع.', '1'),
            const Spacer(),
            const Divider(color: Colors.white12),
            _buildSummaryRow('إجمالي الطلب:', '10,000 د.ع.'),
            _buildSummaryRow('رسوم التوصيل:', '2,000 د.ع.'),
            _buildSummaryRow('المجموع الكلي:', '12,000 د.ع.', isTotal: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onCheckout,
                child: const Text(
                  'إتمام الطلب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String price, String qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF1AD1FF),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.grey,
                onPressed: () {},
              ),
              Text(
                qty,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF1AD1FF),
                onPressed: () {},
              ),
            ],
          ),
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
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
              color: isTotal ? const Color(0xFFFF9500) : Colors.white,
            ),
          ),
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
          Container(
            color: const Color(0xFF1E293B),
            child: const Center(
              child: Icon(
                Icons.map,
                size: 80,
                color: Colors.white24,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'جاري التوصيل...',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1AD1FF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أحمد علي',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'سيارة تيسلا - النجف #1234',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone),
                        color: const Color(0xFF0FB1BD),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'الوصول خلال 12 دقيقة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF1AD1FF),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onBackToHome,
                      child: const Text(
                        'العودة للرئيسية',
                        style: TextStyle(
                          color: Color(0xFF1AD1FF),
                        ),
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
}
