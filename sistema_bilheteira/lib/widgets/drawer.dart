import 'package:flutter/material.dart';

class MainMenuDrawer extends StatelessWidget {
  final Function(int) onMenuItemClicked;

  MainMenuDrawer({required this.onMenuItemClicked});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Clientes'),
            onTap: () {
              onMenuItemClicked(
                  1); // Callback to inform that the Clients menu item was clicked
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Bilhetes'),
            onTap: () {
              onMenuItemClicked(
                  2); // Callback to inform that the Products menu item was clicked
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Inventários'),
            onTap: () {
              onMenuItemClicked(
                  3); // Callback to inform that the Inventory menu item was clicked
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Vendas'),
            onTap: () {
              onMenuItemClicked(
                  4); // Callback to inform that the Sales menu item was clicked
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Relatórios'),
            onTap: () {
              onMenuItemClicked(
                  5); // Callback to inform that the Reports menu item was clicked
            },
          ),

          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Cliente Simulador'),
            onTap: () {
              onMenuItemClicked(
                  6); // Callback to inform that the Reports menu item was clicked
            },
          ),
        ],
      ),
    );
  }
}
