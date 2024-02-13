import 'package:chatychat/services/auth/auth_service.dart';
import 'package:chatychat/components/my_button.dart';
import 'package:chatychat/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //email and pw text controllera

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  //tap to go register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //Login Method
  void login(BuildContext context) async {
    //auth  service
    final authService = AuthService();

    //try loign
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    }

    //catch any error
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(
              height: 50,
            ),
            //Welcome Back Msg
            Text("Welcome back,you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                )),

            const SizedBox(
              height: 25,
            ),

            //email textfeilod
            MyTextFeild(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(
              height: 10,
            ),
            //pw textfeild
            MyTextFeild(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(
              height: 25,
            ),
            //login button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(
              height: 25,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            //register now
          ],
        ),
      ),
    );
  }
}
