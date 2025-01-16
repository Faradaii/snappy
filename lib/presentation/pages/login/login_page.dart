import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/presentation/bloc/auth/auth_bloc.dart';

import '../../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? email;
  TextEditingController? password;

  @override
  void initState() {
    email = TextEditingController(text: '');
    password = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context,) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
            ),
          );

          context.go(PageRouteName.home);
        }

        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          100), // 100 untuk membuat gambar bulat
                      child: Image.asset(
                        "assets/snappy.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Welcome to Snappy",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.2)),
                      Text("Please fill the form below to continue",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w200)),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        CustomTextField(
                          controller: email,
                          hintText: 'Email Address',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill with your email.';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Invalid email.';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: password,
                          hintText: 'Password',
                          obscureText: hidePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill with your password.';
                            }
                            if (value.length < 8) {
                              return 'Minimum 8 characters.';
                            }
                            return null;
                          },
                          onSuffixIconPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          suffixIcon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                            AuthLoginEvent(
                                email: email!.text.trim(),
                                password: password!.text.trim()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width, 50),
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onPrimary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  height: 1.2,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go(PageRouteName.register);
                },
                style: TextButton.styleFrom(
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                    "Create an account"
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}