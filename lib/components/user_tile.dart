import 'package:chatychat/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 25,
        ),
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          //icon
          const Icon(Icons.person),
          const SizedBox(
            width: 20,
          ),

          //user name
          Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.grey.shade900,
            ),
          ),
        ]),
      ),
    );
  }
}
