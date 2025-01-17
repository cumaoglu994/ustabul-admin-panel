import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/categories_screen.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/dashboard_screen.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/hizmet_saglayici.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/rezervasyon_talepler.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/uplaod_banner_screen.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/manage_users.dart';
import 'package:ustabul_web_admin/views/screens/side_bar_screen/proje_yonetimi.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();
  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case ManageUsers.routeName:
        setState(() {
          _selectedItem = ManageUsers();
        });
        break;
      case hizmetDegerlendirme.routeName:
        setState(() {
          _selectedItem = hizmetDegerlendirme();
        });
        break;
      case HizmetSYonetimi.routeName:
        setState(() {
          _selectedItem = HizmetSYonetimi();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;
      case RezervasyonTalepler.routeName:
        setState(() {
          _selectedItem = RezervasyonTalepler();
        });
        break;
      case UplaodBannerScreen.routeName:
        setState(() {
          _selectedItem = UplaodBannerScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: Colors.white,
        sideBar: SideBar(
          items: [
            AdminMenuItem(
              title: 'Dashboard',
              route: DashboardScreen.routeName,
              icon: Icons.dashboard,
            ),
            AdminMenuItem(
              title: 'Kullanıcı Yönetimi',
              route: ManageUsers.routeName,
              icon: Icons.person_3,
            ),
            AdminMenuItem(
              title: 'Hizmet Degerlendirme',
              route: hizmetDegerlendirme.routeName,
              icon: Icons.money,
            ),
            AdminMenuItem(
              title: 'Hizmet  Yönetimi',
              route: HizmetSYonetimi.routeName,
              icon: Icons.shopping_cart,
            ),
            AdminMenuItem(
              title: 'Categories',
              route: CategoriesScreen.routeName,
              icon: Icons.category,
            ),
            AdminMenuItem(
              title: 'Rezervasyon ve Talepler',
              route: RezervasyonTalepler.routeName,
              icon: Icons.shop,
            ),
            AdminMenuItem(
              title: 'Upload Banners',
              route: UplaodBannerScreen.routeName,
              icon: Icons.add,
            ),
          ],
          selectedRoute: '',
          onSelected: (item) {
            screenSelector(item);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'Ustabul Panel ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          footer: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'footer',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('Management'),
        ),
        body: _selectedItem);
  }
}
