import 'package:chat_app/widgets/button_blue.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/list_padding.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ListPadding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Logo(title: 'Fakessenger',),
                    _Form(),
                    Labels(
                      route: 'register',
                      title: '¿No tienes cuenta?',
                      subtitle: 'Crea una ahora!',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          CustomInput(
              controller: emailController,
              icon: Icons.mail_outline,
              placeHolder: 'Email',
              inputType: TextInputType.emailAddress),
          CustomInput(
            controller: passwordController,
            icon: Icons.lock_open_outlined,
            placeHolder: 'Password',
            inputType: TextInputType.visiblePassword,
            isPassword: true,
          ),
          ButtonBlue(onTap: () {}, text: 'Ingrese')
        ],
      ),
    );
  }
}
