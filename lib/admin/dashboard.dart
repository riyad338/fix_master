import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_masters/admin/add_location.dart';
import 'package:fix_masters/admin/add_new_type.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/customwidgets/dashboardbutton.dart';
import 'package:fix_masters/pages/login_page.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigoAccent.shade100,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout().then((_) =>
                  Navigator.pushReplacementNamed(context, LoginPage.routeName));
              showToastMsg("Logout Successfully");
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: [
          DashboardButton(
            label: 'Add New Type',
            onPressed: () =>
                Navigator.pushNamed(context, AddNewTypePage.routeName),
          ),
          DashboardButton(
            label: 'Add New Location',
            onPressed: () =>
                Navigator.pushNamed(context, AddNewLocationPage.routeName),
          ),
          // DashboardButton(
          //   label: 'Update User\n   Product',
          //   onPressed: () =>
          //       Navigator.pushNamed(context, UpdateProductPage.routeName),
          // ),
          // DashboardButton(
          //   label: 'Update Distributor\n        Product',
          //   onPressed: () => Navigator.pushNamed(
          //       context, DistributorProductListPage.routeName),
          // ),
          // DashboardButton(
          //   label: 'Pending User\n     Orders',
          //   onPressed: () =>
          //       Navigator.pushNamed(context, PendingOrderPage.routeName),
          // ),
          // DashboardButton(
          //   label: 'All User Orders',
          //   onPressed: () =>
          //       Navigator.pushNamed(context, AllOrdersPage.routeName),
          // ),
          // DashboardButton(
          //   label: 'All Distributor\n      Orders',
          //   onPressed: () => Navigator.pushNamed(
          //       context, AllDistributorOrdersPage.routeName),
          // ),
          // DashboardButton(
          //   label: 'Categories Page',
          //   onPressed: () =>
          //       Navigator.pushNamed(context, CategorieAddPage.routeName),
          // ),
          // DashboardButton(
          //   label: 'OrderConstants',
          //   onPressed: () =>
          //       Navigator.pushNamed(context, OrderConstantsPage.routeName),
          // ),
        ],
      ),
    );
  }
}
