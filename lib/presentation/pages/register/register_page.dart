import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/presentation/bloc/auth/auth_bloc.dart';
import 'package:snappy/presentation/widgets/rotating_widget.dart';

import '../../../common/localizations/common.dart';
import '../../widgets/bottom_auth_text.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/flag_language.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? email;
  TextEditingController? name;
  TextEditingController? password;

  @override
  void initState() {
    email = TextEditingController(text: '');
    name = TextEditingController(text: '');
    password = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
            ),
          );
          context.pop();
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
          bottomNavigationBar: BottomAuthText(
            title: AppLocalizations.of(context)!.askForAnAccountRegister,
            body: AppLocalizations.of(context)!.offerLogin,
            onPressed: () {
              context.pop();
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  FlagLanguage(),
                  RotatingWidget(widget: SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/snappy.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),),
                  Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.welcomeBack,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.2)),
                      Text(AppLocalizations.of(context)!.fillFormBelow,
                          textAlign: TextAlign.center,
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
            controller: name,
            hintText: AppLocalizations.of(context)!.name,
            prefixIcon: Icon(Icons.abc_rounded),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.pleaseFillName;
              }
              return null;
            },
          ),
          CustomTextField(
            controller: email,
            hintText: AppLocalizations.of(context)!.emailAddress,
            prefixIcon: Icon(Icons.email_rounded),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.pleaseFillEmail;
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return AppLocalizations.of(context)!.invalidEmail;
              }
              return null;
            },
          ),
          CustomTextField(
            controller: password,
            hintText: AppLocalizations.of(context)!.password,
            obscureText: hidePassword,
            prefixIcon: Icon(Icons.password_rounded),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.pleaseFillPassword;
              }
              if (value.length < 8) {
                return AppLocalizations.of(context)!.invalidPassword;
              }
              return null;
            },
            onSuffixIconPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            suffixIcon: Icon(
              hidePassword ? Icons.visibility_off : Icons.remove_red_eye,
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
          context.read<AuthBloc>().add(AuthRegisterEvent(
              name: name!.text.trim(),
              email: email!.text.trim(),
              password: password!.text.trim()));
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: state is AuthLoadingState
          ? CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary)
          : Text(
              AppLocalizations.of(context)!.register,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
    );
  }
}
