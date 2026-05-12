import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'pages/login/login_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/system/user_management_page.dart';
import 'pages/system/role_management_page.dart';
import 'pages/basic_data/product_page.dart';
import 'pages/basic_data/supplier_page.dart';
import 'pages/basic_data/customer_page.dart';
import 'pages/purchase/purchase_order_page.dart';
import 'pages/purchase/purchase_return_page.dart';
import 'pages/sales/sales_order_page.dart';
import 'pages/sales/sales_return_page.dart';
import 'pages/inventory/stock_page.dart';
import 'pages/inventory/stock_check_page.dart';
import 'pages/reports/report_pages.dart';
import 'widgets/app_layout.dart';

void main() {
  runApp(const ProviderScope(child: WMSApp()));
}

class WMSApp extends StatelessWidget {
  const WMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMS 进销存管理系统',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1e293b),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String _currentRoute = '/dashboard';

  final Map<String, Widget> _pages = {};

  @override
  void initState() {
    super.initState();
    _pages.addAll({
      '/dashboard': const DashboardPage(),
      '/system/users': const UserManagementPage(),
      '/system/roles': const RoleManagementPage(),
      '/basic/products': const ProductPage(),
      '/basic/suppliers': const SupplierPage(),
      '/basic/customers': const CustomerPage(),
      '/purchase/orders': const PurchaseOrderPage(),
      '/purchase/returns': const PurchaseReturnPage(),
      '/sales/orders': const SalesOrderPage(),
      '/sales/returns': const SalesReturnPage(),
      '/inventory/stock': const StockPage(),
      '/inventory/check': const StockCheckPage(),
      '/reports/sales': const SalesReportPage(),
      '/reports/purchase': const PurchaseReportPage(),
      '/reports/inventory': const InventoryReportPage(),
    });
  }

  String _getTitle(String route) {
    final titles = {
      '/dashboard': '首页',
      '/system/users': '用户管理',
      '/system/roles': '角色管理',
      '/basic/products': '商品管理',
      '/basic/suppliers': '供应商管理',
      '/basic/customers': '客户管理',
      '/purchase/orders': '采购订单',
      '/purchase/returns': '采购退货',
      '/sales/orders': '销售订单',
      '/sales/returns': '销售退货',
      '/inventory/stock': '库存查询',
      '/inventory/check': '库存盘点',
      '/reports/sales': '销售报表',
      '/reports/purchase': '采购报表',
      '/reports/inventory': '库存报表',
    };
    return titles[route] ?? '首页';
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) {
      return LoginPage(
        onLoginSuccess: () {},
      );
    }

    return AppLayout(
      title: _getTitle(_currentRoute),
      currentRoute: _currentRoute,
      onRouteChanged: (route) {
        if (_pages.containsKey(route)) {
          setState(() => _currentRoute = route);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(_currentRoute),
          child: _pages[_currentRoute] ?? const DashboardPage(),
        ),
      ),
    );
  }
}
