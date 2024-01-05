import 'package:flutter/material.dart';

class ListTiles extends StatelessWidget {
  const ListTiles({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key});
  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
      ),
      title: Text(title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
      ),
      onTap: onTap,
    );
  }
}
