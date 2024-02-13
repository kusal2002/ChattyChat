import 'package:chatychat/services/auth/auth_service.dart';
import 'package:chatychat/pages/settings_page.dart';
import 'package:chatychat/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    //get auth servive

    final auth = AuthService();
    auth.SignOut();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

              //home list title
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: isDarkMode ? Colors.white : Colors.grey.shade900,
                  ),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              //settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("S E T T I N G S",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey.shade900,
                      )),
                  leading: Icon(
                    Icons.settings,
                    color: isDarkMode ? Colors.white : Colors.grey.shade900,
                  ),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: Text("L O G O U T",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.grey.shade900,
                  )),
              leading: Icon(
                Icons.logout,
                color: isDarkMode ? Colors.white : Colors.grey.shade900,
              ),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
