import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/theme.dart';
import 'providers/providers.dart';
import 'pages/login/login_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/system/user_management_page.dart';
import 'pages/system/role_management_page.dart';
import 'pages/basic_data/product_page.dart';
import 'pages/basic_data/supplier_page.dart';
import 'pages/basic_data/customer_page.dart';
import 'pages/basic_data/warehouse_page.dart';
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

class WMSApp extends ConsumerWidget {
  const WMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkThemeProvider);
    return MaterialApp(
      title: '企业进销存管理系统',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme(),
      darkTheme: AppThemeData.darkTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
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

  static const _routeTitles = {
    '/dashboard': '首页',
    '/system/users': '用户管理',
    '/system/roles': '角色管理',
    '/basic/products': '商品管理',
    '/basic/suppliers': '供应商管理',
    '/basic/customers': '客户管理',
    '/basic/warehouses': '仓库管理',
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

  String _getTitle(String route) => _routeTitles[route] ?? '首页';

  Widget _buildPage(String route) {
    switch (route) {
      case '/dashboard':
        return DashboardPage(
          onNavigate: (r) {
            if (_routeTitles.containsKey(r)) {
              setState(() => _currentRoute = r);
            }
          },
        );
      case '/system/users': return const UserManagementPage();
      case '/system/roles': return const RoleManagementPage();
      case '/basic/products': return const ProductPage();
      case '/basic/suppliers': return const SupplierPage();
      case '/basic/customers': return const CustomerPage();
      case '/basic/warehouses': return const WarehousePage();
      case '/purchase/orders': return const PurchaseOrderPage();
      case '/purchase/returns': return const PurchaseReturnPage();
      case '/sales/orders': return const SalesOrderPage();
      case '/sales/returns': return const SalesReturnPage();
      case '/inventory/stock': return const StockPage();
      case '/inventory/check': return const StockCheckPage();
      case '/reports/sales': return const SalesReportPage();
      case '/reports/purchase': return const PurchaseReportPage();
      case '/reports/inventory': return const InventoryReportPage();
      default: return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) {
      return LoginPage(onLoginSuccess: () {});
    }

    return AppLayout(
      title: _getTitle(_currentRoute),
      currentRoute: _currentRoute,
      onRouteChanged: (route) {
        if (_routeTitles.containsKey(route)) {
          setState(() => _currentRoute = route);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(_currentRoute),
          child: _buildPage(_currentRoute),
        ),
      ),
    );
  }
}
