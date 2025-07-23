import 'package:chat_app/core/widgets/rounded_button_widget.dart';
import 'package:chat_app/core/widgets/text_field_widget.dart';
import 'package:chat_app/feature/auth/presentation/blocs/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

late TextEditingController _emailController;

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(forceMaterialTransparency: true),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              toastification.show(
                autoCloseDuration: Duration(seconds: 10),
                title: Text('We have sent password reset link to your email'),
                style: ToastificationStyle.fillColored,
                type: ToastificationType.info,
                showProgressBar: true,
                icon: Icon(Icons.check),
                showIcon: true,
              );
              if (state is AuthError) {
                toastification.show(
                  title: Text('Some error occured'),
                  description: Text(state.toString()),
                  style: ToastificationStyle.minimal,
                  type: ToastificationType.error,
                  showIcon: true,
                );
              }
            }
          },
          builder: (context, state) {
            return Form(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter your \nEmail',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'We will sent a reset verification link to your email',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  TextFieldWidget(
                    hintText: 'Enter your email',
                    icon: Icons.mail_outline_outlined,
                    controller: _emailController,
                  ),
                  RoundedButtonWidget(
                    label: 'Reset Password',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        ForgotPasswordEvent(
                          email: _emailController.text.trim(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
