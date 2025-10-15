import 'package:flutter/material.dart';
import 'login_page.dart'; // ✅ thêm dòng này

void main() {
  runApp(const HomeTest());
}

class HomeTest extends StatelessWidget {
  const HomeTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Điện Nước',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        primaryColor: const Color(0xFF0F3460),
        cardColor: const Color(0xFF16213E),
      ),
      home: const HomePage(),
    );
  }
}

// ------------------- TỪ ĐÂY LÀ CODE CŨ -------------------

class ApartmentData {
  String name;
  double electricValue;
  double waterValue;
  double electricThreshold;
  double waterThreshold;
  String ownerName;
  String customerId;

  ApartmentData({
    required this.name,
    this.electricValue = 0,
    this.waterValue = 0,
    this.electricThreshold = 100,
    this.waterThreshold = 50,
    this.ownerName = 'Duy',
    this.customerId = 'KH001',
  });

  bool get isElectricAlert => electricValue > electricThreshold;
  bool get isWaterAlert => waterValue > waterThreshold;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<ApartmentData> apartments = [
    ApartmentData(
      name: 'Căn hộ 1',
      electricValue: 20,
      waterValue: 200,
      customerId: 'KH001',
    ),
    ApartmentData(
      name: 'Căn hộ 2',
      electricValue: 150,
      waterValue: 80,
      customerId: 'KH002',
    ),
    ApartmentData(
      name: 'Căn hộ 3',
      electricValue: 50,
      waterValue: 30,
      customerId: 'KH003',
    ),
    ApartmentData(
      name: 'Căn hộ 4',
      electricValue: 200,
      waterValue: 100,
      customerId: 'KH004',
    ),
    ApartmentData(
      name: 'Căn hộ 5',
      electricValue: 75,
      waterValue: 45,
      customerId: 'KH005',
    ),
    ApartmentData(
      name: 'Căn hộ 6',
      electricValue: 110,
      waterValue: 60,
      customerId: 'KH006',
    ),
  ];

  void _addApartment() {
    setState(() {
      apartments.add(
        ApartmentData(
          name: 'Căn hộ ${apartments.length + 1}',
          electricValue: 0,
          waterValue: 0,
          customerId: 'KH${(apartments.length + 1).toString().padLeft(3, '0')}',
        ),
      );
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm căn hộ mới')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QUẢN LÝ ĐIỆN NƯỚC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F3460),
        actions: const [
          Icon(Icons.home),
          SizedBox(width: 8),
          Icon(Icons.water_drop),
          SizedBox(width: 16),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF16213E),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Thêm'),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Khu phố',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildAddPage();
      case 1:
        return _buildOverviewPage();
      case 2:
        return _buildStatisticsPage();
      case 3:
        return _buildAccountPage();
      default:
        return _buildOverviewPage();
    }
  }

  Widget _buildAddPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_home, size: 80, color: Colors.pinkAccent),
          const SizedBox(height: 24),
          const Text(
            'Thêm Căn Hộ Mới',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Hiện có ${apartments.length} căn hộ',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addApartment,
            icon: const Icon(Icons.add),
            label: const Text('Thêm Căn Hộ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewPage() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: apartments.length,
      itemBuilder: (context, index) {
        return _buildApartmentCard(apartments[index], index);
      },
    );
  }

  Widget _buildStatisticsPage() {
    int totalAlerts =
        apartments.where((a) => a.isElectricAlert || a.isWaterAlert).length;
    double totalElectric = apartments.fold(
      0,
      (sum, a) => sum + a.electricValue,
    );
    double totalWater = apartments.fold(0, (sum, a) => sum + a.waterValue);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatCard(
          'Tổng số căn hộ',
          apartments.length.toString(),
          Icons.apartment,
          Colors.blue,
        ),
        _buildStatCard(
          'Cảnh báo',
          totalAlerts.toString(),
          Icons.warning,
          Colors.orange,
        ),
        _buildStatCard(
          'Tổng điện',
          '${totalElectric.toStringAsFixed(0)} w',
          Icons.bolt,
          Colors.yellow,
        ),
        _buildStatCard(
          'Tổng nước',
          '${totalWater.toStringAsFixed(0)} L',
          Icons.water_drop,
          Colors.cyan,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.pinkAccent,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Quản Trị Viên',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'admin@quanlydiennuoc.vn',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        _buildAccountOption(Icons.settings, 'Cài đặt'),
        _buildAccountOption(Icons.notifications, 'Thông báo'),
        _buildAccountOption(Icons.help, 'Trợ giúp'),

        // ✅ Sửa phần Đăng xuất
        _buildAccountOption(
          Icons.logout,
          'Đăng xuất',
          isRed: true,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccountOption(
    IconData icon,
    String title, {
    bool isRed = false,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: isRed ? Colors.red : Colors.pinkAccent),
        title: Text(title, style: TextStyle(color: isRed ? Colors.red : null)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap ?? () {},
      ),
    );
  }

  Widget _buildApartmentCard(ApartmentData apt, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentDetailPage(apartment: apt),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF9DB4C0).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.yellowAccent, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Số điện: ${apt.electricValue.toStringAsFixed(0)}w',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.water_drop,
                  color: Colors.lightBlueAccent,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Số nước: ${apt.waterValue.toStringAsFixed(0)}L',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Alert 1', style: TextStyle(fontSize: 10)),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.wb_sunny,
                      color: apt.isElectricAlert ? Colors.yellow : Colors.grey,
                      size: 28,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Alert 2', style: TextStyle(fontSize: 10)),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.wb_sunny,
                      color: apt.isWaterAlert ? Colors.yellow : Colors.grey,
                      size: 28,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A9D8F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    apt.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApartmentDetailPage extends StatelessWidget {
  final ApartmentData apartment;
  const ApartmentDetailPage({Key? key, required this.apartment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.name),
        backgroundColor: const Color(0xFF0F3460),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF9DB4C0).withOpacity(0.3),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFF7DB9DE)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    apartment.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(Icons.refresh, color: Colors.black87),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      apartment.name,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'Mã khách hàng: ${apartment.customerId}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Họ và tên chủ hộ:',
                      apartment.ownerName,
                      false,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Số Điện',
                      '${apartment.electricValue.toStringAsFixed(2)} w',
                      apartment.isElectricAlert,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Số nước',
                      '${apartment.waterValue.toStringAsFixed(0)} L',
                      apartment.isWaterAlert,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Alarm 1 (Điện)',
                      apartment.isElectricAlert ? 'ON' : 'OFF',
                      apartment.isElectricAlert,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Alarm 2 (Nước)',
                      apartment.isWaterAlert ? 'ON' : 'OFF',
                      apartment.isWaterAlert,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isAlert) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
