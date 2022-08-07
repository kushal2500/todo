import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
            ),
            accountName: Text('Kushal Bohra'),
            accountEmail: Text('kushaljain2500@gmail.com'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
              leading: Icon(Icons.home), title: Text('Home'), onTap: () {}),
          ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: () {}),
        ],
      ),
    );
  }
}
