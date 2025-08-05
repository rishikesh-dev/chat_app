import 'package:chat_app/core/widgets/rounded_button_widget.dart';
import 'package:chat_app/core/widgets/text_field_widget.dart';
import 'package:chat_app/feature/auth/presentation/blocs/bloc/auth_bloc.dart';
import 'package:chat_app/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:chat_app/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

late TextEditingController _nameController;
late TextEditingController _emailController;
late TextEditingController _passwordController;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(forceMaterialTransparency: true),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create new \nAccount',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.displayMedium!.fontFamily,
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        controller: _nameController,
                        hintText: 'Name',
                        icon: Icons.person_2_outlined,
                        validator: (value) {
                          if (value == null) {
                            return 'Please fill the form';
                          }
                          return null;
                        },
                      ),
                      TextFieldWidget(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.mail_outlined,
                        validator: (value) {
                          if (value == null) {
                            return 'Please fill the form';
                          }
                          if (!value.toString().contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFieldWidget(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline_rounded,
                        isObscure: isObscure,
                        isPassword: true,
                        validator: (value) {
                          if (value == null) {
                            return 'Please fill the form';
                          }
                          if (value.toString().length < 6) {
                            return 'Password length is short';
                          }
                          return null;
                        },
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      RoundedButtonWidget(
                        label: 'Create Account',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              CreateAccountEvent(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                            setState(() {});
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => SignInScreen(),
                                    ),
                                  );
                                },
                              text: 'Sign In',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
