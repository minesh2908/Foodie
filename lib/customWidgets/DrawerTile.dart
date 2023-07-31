import 'package:flutter/material.dart';


class DrawerOptions extends StatelessWidget {
  const DrawerOptions({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.black45,
        size: 32,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black45, fontSize: 20),
      ),
    );
  }
}