import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/presentation/bloc/auth/auth_bloc.dart';

import '../../widgets/bottom_auth_text.dart';
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
        if (state is AuthLoginSuccessState) {
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
          bottomNavigationBar: BottomAuthText(title: "Don't have an account?",
            body: "Create an account",
            onPressed: () {
              context.push(PageRouteName.register);
            },),
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
                          100),
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
                      Text("Welcome back to Snappy",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.2)),
                      Text("Please fill the form below to continue",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w200)),
                    ],
                  ),
                  _buildForm(),
                  _buildAuthButton(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10,
        children: [
          CustomTextField(
            controller: email,
            hintText: 'Email Address',
            prefixIcon: Icon(Icons.email_rounded),
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
            prefixIcon: Icon(Icons.password_rounded),
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
    );
  }

  Widget _buildAuthButton(AuthState state) {
    return ElevatedButton(
      onPressed: () {
        if (state is AuthLoadingState) {
          null;
        } else if (_formKey.currentState!.validate()) {
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
      child: state is AuthLoadingState ? CircularProgressIndicator(color: Theme
          .of(context)
          .colorScheme
          .onPrimary) : Text(
        'Login',
        style: TextStyle(
          color: Theme
              .of(context)
              .colorScheme
              .onPrimary,
          fontSize: 20,
        ),
      ),
    );
  }


}