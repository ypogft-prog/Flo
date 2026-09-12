import 'package:flutter/material.dart';

const _navy = Color(0xFF17112F);
const _navy2 = Color(0xFF0D0920);
const _gold = Color(0xFFD4AF37);
const _bg = Color(0xFFF8F7FB);
const _muted = Color(0xFF777486);

class FLOApp extends StatelessWidget {
  const FLOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FLO',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _bg,
        colorScheme: ColorScheme.fromSeed(seedColor: _navy),
        appBarTheme: const AppBarTheme(
          backgroundColor: _navy,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
      home: const FLOHome(),
    );
  }
}

class FLOHome extends StatefulWidget {
  const FLOHome({super.key});
  @override
  State<FLOHome> createState() => _FLOHomeState();
}

class _FLOHomeState extends State<FLOHome> {
  int _index = 0;
  final List<String> _cart = [];
  double _wallet = 0;

  void _addToCart(String item) {
    setState(() => _cart.add(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$item أضيف إلى السلة'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(onAdd: _addToCart, onTaxi: () => _openTaxi(context)),
      _OrdersTab(),
      _WalletTab(balance: _wallet, onAdd: (amount) => setState(() => _wallet += amount)),
      _CartTab(items: _cart, onClear: () => setState(_cart.clear)),
      const _AccountTab(),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          backgroundColor: Colors.white,
          indicatorColor: _gold.withOpacity(.18),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'الطلبات'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'المحفظة'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'السلة'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'الحساب'),
          ],
        ),
      ),
    );
  }

  void _openTaxi(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _TaxiScreen()));
  }
}

class _HomeTab extends StatelessWidget {
  final void Function(String) onAdd;
  final VoidCallback onTaxi;
  const _HomeTab({required this.onAdd, required this.onTaxi});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('مطاعم', Icons.restaurant_rounded),
      ('صيدليات', Icons.local_pharmacy_rounded),
      ('أدوية', Icons.medication_rounded),
      ('ورد', Icons.local_florist_rounded),
      ('هدايا', Icons.card_giftcard_rounded),
      ('إكسسوارات', Icons.watch_rounded),
      ('متاجر', Icons.storefront_rounded),
      ('تكسي', Icons.local_taxi_rounded),
    ];
    final products = ['برغر FLO', 'بيتزا خاصة', 'دواء', 'باقة ورد فاخرة'];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _hero(context, onTaxi)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          sliver: SliverToBoxAdapter(child: _sectionTitle('خدمات FLO', 'عرض الكل')),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: .82),
            itemCount: categories.length,
            itemBuilder: (_, i) => _CategoryTile(label: categories[i].$1, icon: categories[i].$2, onTap: () {
              if (i == 7) { onTaxi(); return; }
              Navigator.push(context, MaterialPageRoute(builder: (_) => _ServiceScreen(title: categories[i].$1, onAdd: onAdd)));
            }),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          sliver: SliverToBoxAdapter(child: _sectionTitle('الأكثر طلباً', 'المزيد')),
        ),
        SliverList.builder(
          itemCount: products.length,
          itemBuilder: (_, i) => _ProductTile(name: products[i], price: 7500 + i * 1500, onAdd: onAdd),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

Widget _hero(BuildContext context, VoidCallback onTaxi) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [_navy2, _navy]),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Expanded(child: Text('FLO', style: TextStyle(color: _gold, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 3))),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
      ]),
      const SizedBox(height: 8),
      const Text('كل احتياجاتك في مكان واحد', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('توصيل سريع • خدمات متنوعة • تجربة فاخرة', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 18),
      InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _SearchScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: const Row(children: [Icon(Icons.search, color: _muted), SizedBox(width: 10), Text('ابحث عن مطعم، دواء أو متجر...', style: TextStyle(color: _muted))]),
        ),
      ),
      const SizedBox(height: 14),
      OutlinedButton.icon(
        onPressed: onTaxi,
        icon: const Icon(Icons.local_taxi, color: _gold),
        label: const Text('اطلب تكسي الآن', style: TextStyle(color: Colors.white)),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: _gold), minimumSize: const Size(double.infinity, 48)),
      ),
    ]),
  );
}

Widget _sectionTitle(String title, String action) => Row(children: [
  Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: _navy)),
  const Spacer(),
  Text(action, style: const TextStyle(color: _gold, fontWeight: FontWeight.w700)),
]);

class _CategoryTile extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _CategoryTile({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Column(children: [
      Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x10000000))]), child: Icon(icon, color: _gold, size: 29)),
      const SizedBox(height: 7),
      Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ProductTile extends StatelessWidget {
  final String name; final int price; final void Function(String) onAdd;
  const _ProductTile({required this.name, required this.price, required this.onAdd});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      leading: Container(width: 52, height: 52, decoration: BoxDecoration(color: _navy, borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.fastfood, color: _gold)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$price د.ع', style: const TextStyle(color: _gold, fontWeight: FontWeight.bold)),
      trailing: IconButton(onPressed: () => onAdd(name), icon: const Icon(Icons.add_circle, color: _navy)),
    ),
  );
}

class _ServiceScreen extends StatelessWidget {
  final String title; final void Function(String) onAdd;
  const _ServiceScreen({required this.title, required this.onAdd});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView.builder(itemCount: 8, padding: const EdgeInsets.all(12), itemBuilder: (_, i) => _ProductTile(name: '$title ${i + 1}', price: 5000 + i * 1250, onAdd: onAdd)),
  );
}

class _OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SimpleTab(title: 'الطلبات', icon: Icons.receipt_long, child: Column(children: [
    _OrderCard(status: 'قيد التجهيز', store: 'مطعم FLO', total: '18,500 د.ع'),
    _OrderCard(status: 'تم التوصيل', store: 'صيدلية FLO', total: '12,000 د.ع'),
  ]));
}

class _OrderCard extends StatelessWidget {
  final String status, store, total;
  const _OrderCard({required this.status, required this.store, required this.total});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: const CircleAvatar(backgroundColor: _navy, child: Icon(Icons.shopping_bag, color: _gold)), title: Text(store, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(status), trailing: Text(total, style: const TextStyle(fontWeight: FontWeight.bold))));
}

class _WalletTab extends StatelessWidget {
  final double balance; final ValueChanged<double> onAdd;
  const _WalletTab({required this.balance, required this.onAdd});
  @override
  Widget build(BuildContext context) => _SimpleTab(title: 'محفظة FLO', icon: Icons.account_balance_wallet, child: Column(children: [
    Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [_navy2, _navy]), borderRadius: BorderRadius.circular(22)), child: Column(children: [const Text('الرصيد المتاح', style: TextStyle(color: Colors.white70)), const SizedBox(height: 8), Text('${balance.toStringAsFixed(0)} د.ع', style: const TextStyle(color: _gold, fontSize: 30, fontWeight: FontWeight.w900))])),
    const SizedBox(height: 18),
    ElevatedButton.icon(onPressed: () async { final amount = await showDialog<double>(context: context, builder: (_) => const _AmountDialog()); if (amount != null && amount > 0) onAdd(amount); }, icon: const Icon(Icons.add), label: const Text('إضافة رصيد')),
    const SizedBox(height: 12),
    const ListTile(leading: Icon(Icons.history), title: Text('سجل العمليات'), trailing: Icon(Icons.chevron_left)),
  ]));
}

class _AmountDialog extends StatefulWidget { const _AmountDialog(); @override State<_AmountDialog> createState() => _AmountDialogState(); }
class _AmountDialogState extends State<_AmountDialog> {
  final c = TextEditingController();
  @override Widget build(BuildContext context) => AlertDialog(title: const Text('إضافة رصيد'), content: TextField(controller: c, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'المبلغ بالدينار')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), TextButton(onPressed: () => Navigator.pop(context, double.tryParse(c.text)), child: const Text('إضافة'))]);
  @override void dispose() { c.dispose(); super.dispose(); }
}

class _CartTab extends StatelessWidget {
  final List<String> items; final VoidCallback onClear;
  const _CartTab({required this.items, required this.onClear});
  @override Widget build(BuildContext context) => _SimpleTab(title: 'السلة', icon: Icons.shopping_bag, child: items.isEmpty ? const _Empty(text: 'السلة فارغة') : Column(children: [for (final item in items) ListTile(leading: const Icon(Icons.fastfood), title: Text(item), trailing: const Text('مضاف')), const SizedBox(height: 10), ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _CheckoutScreen())), child: const Text('متابعة إلى الدفع')), TextButton(onPressed: onClear, child: const Text('تفريغ السلة'))]));
}

class _AccountTab extends StatelessWidget { const _AccountTab(); @override Widget build(BuildContext context) => _SimpleTab(title: 'الحساب', icon: Icons.person, child: Column(children: [const CircleAvatar(radius: 42, backgroundColor: _navy, child: Icon(Icons.person, size: 48, color: _gold)), const SizedBox(height: 12), const Text('مستخدم FLO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 20), for (final x in ['العناوين', 'المفضلة', 'الإعدادات', 'الدعم والمساعدة']) Card(child: ListTile(title: Text(x), trailing: const Icon(Icons.chevron_left)))])); }

class _SimpleTab extends StatelessWidget {
  final String title; final IconData icon; final Widget child;
  const _SimpleTab({required this.title, required this.icon, required this.child});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [Row(children: [Icon(icon, color: _gold), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _navy))]), const SizedBox(height: 22), child]));
}

class _TaxiScreen extends StatefulWidget { const _TaxiScreen(); @override State<_TaxiScreen> createState() => _TaxiScreenState(); }
class _TaxiScreenState extends State<_TaxiScreen> {
  String payment = 'محفظة FLO';
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('FLO Taxi')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Container(height: 270, width: double.infinity, decoration: BoxDecoration(color: _navy, borderRadius: BorderRadius.circular(22)), child: const Center(child: Icon(Icons.map, color: _gold, size: 90))), const SizedBox(height: 16), const TextField(decoration: InputDecoration(labelText: 'موقع الانطلاق', prefixIcon: Icon(Icons.my_location))), const SizedBox(height: 10), const TextField(decoration: InputDecoration(labelText: 'الوجهة', prefixIcon: Icon(Icons.location_on))), const SizedBox(height: 16), DropdownButtonFormField<String>(value: payment, items: const [DropdownMenuItem(value: 'محفظة FLO', child: Text('محفظة FLO')), DropdownMenuItem(value: 'بطاقة مصرفية', child: Text('بطاقة مصرفية')), DropdownMenuItem(value: 'دفع نقدي', child: Text('دفع نقدي'))], onChanged: (v) => setState(() => payment = v ?? payment), decoration: const InputDecoration(labelText: 'طريقة الدفع')), const Spacer(), ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _TaxiTrackingScreen())), child: const Text('تأكيد طلب التكسي'))])));
}

class _TaxiTrackingScreen extends StatelessWidget { const _TaxiTrackingScreen(); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('رحلة FLO')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Container(height: 330, width: double.infinity, decoration: BoxDecoration(color: _navy, borderRadius: BorderRadius.circular(22)), child: const Center(child: Icon(Icons.navigation, color: _gold, size: 90))), const SizedBox(height: 20), const Text('جاري البحث عن سائق قريب منك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('سيتم تحديث حالة الرحلة عند العثور على السائق.'), const Spacer(), ElevatedButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('العودة للرئيسية'))]))); }

class _CheckoutScreen extends StatefulWidget { const _CheckoutScreen(); @override State<_CheckoutScreen> createState() => _CheckoutScreenState(); }
class _CheckoutScreenState extends State<_CheckoutScreen> { String payment = 'دفع نقدي'; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تأكيد الطلب')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [const ListTile(title: Text('العنوان'), subtitle: Text('النجف الأشرف - العنوان الافتراضي'), trailing: Icon(Icons.location_on)), const Divider(), const ListTile(title: Text('المجموع'), trailing: Text('18,500 د.ع')), DropdownButtonFormField<String>(value: payment, items: const [DropdownMenuItem(value: 'دفع نقدي', child: Text('دفع نقدي')), DropdownMenuItem(value: 'بطاقة مصرفية', child: Text('بطاقة مصرفية')), DropdownMenuItem(value: 'محفظة FLO', child: Text('محفظة FLO'))], onChanged: (v) => setState(() => payment = v ?? payment), decoration: const InputDecoration(labelText: 'طريقة الدفع')), const Spacer(), ElevatedButton(onPressed: () { showDialog(context: context, builder: (_) => AlertDialog(title: const Text('تم تأكيد الطلب'), content: const Text('تم إرسال طلبك إلى أقرب سائق متاح.'), actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('ممتاز'))])); }, child: const Text('تأكيد الطلب'))]))); }

class _SearchScreen extends StatelessWidget { const _SearchScreen(); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('البحث')), body: const Padding(padding: EdgeInsets.all(16), child: TextField(autofocus: true, decoration: InputDecoration(hintText: 'اكتب ما تبحث عنه...', prefixIcon: Icon(Icons.search))))); }

class _Empty extends StatelessWidget { final String text; const _Empty({required this.text}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [const Icon(Icons.inbox_outlined, size: 70, color: _muted), const SizedBox(height: 12), Text(text, style: const TextStyle(color: _muted, fontSize: 17))]))); }

