import 'package:chat_app/core/widgets/rounded_button_widget.dart';
import 'package:chat_app/core/widgets/text_field_widget.dart';
import 'package:chat_app/feature/auth/presentation/blocs/bloc/auth_bloc.dart';
import 'package:chat_app/feature/auth/presentation/screens/forgot_password.dart';
import 'package:chat_app/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:chat_app/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  bool isObscure = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          child: Center(
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
                        'Welcome \nBack',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.mail_outlined,
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: Text('Forgot password?'),
                      ),
                    ),
                    RoundedButtonWidget(
                      label: 'Log In',

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          context.read<AuthBloc>().add(
                            SignInAccountEvent(
                              email: email,
                              password: password,
                            ),
                          );
                        }
                        setState(() {});
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(builder: (ctx) => HomeScreen()),
                        );
                      },
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Doesn\'t have an account?',
                        children: [
                          TextSpan(
                            text: ' Create account',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
