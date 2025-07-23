import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/theme/theme_cubit.dart';
import 'package:chat_app/feature/auth/presentation/screens/forgot_password.dart';
import 'package:chat_app/feature/profile/presentation/bloc/update_account_bloc.dart';
import 'package:chat_app/feature/profile/presentation/screens/my_account_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class SettingsScreen extends StatelessWidget {
  final User user;
  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: BlocConsumer<UpdateAccountBloc, UpdateAccountState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              toastification.show(
                title: Text('Your Account has been deleted successfully'),
                description: Text(
                  'Thanks for using my app🙏🫂\n you will redirected to welcome screen',
                ),
              );
            }
            if (state is UpdateAccountError) {
              toastification.show(
                title: Text('Your Account deletion failed'),
                description: Text('Sorry for that😔,please try again'),
              );
            }
            if (state is UpdateAccountSuccess) {
              toastification.show(
                title: Text('Your name has changed successfully'),
              );
            }
            if (state is UpdateAccountError) {
              toastification.show(
                showProgressBar: true,
                showIcon: false,
                title: Text('Your name has Failed'),
                description: Text(state.message),
              );
            }
          },
          builder: (context, state) {
            final themeMode = context.watch<ThemeCubit>().state;
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (ctx) => MyAccountScreens(user: user),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(
                        context,
                      ).cardColor.withValues(alpha: 0.20),
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          foregroundColor: Theme.of(
                            context,
                          ).scaffoldBackgroundColor,
                          backgroundColor: Theme.of(context).cardColor,
                          child: Text(
                            user.userMetadata?['name']
                                    .toString()
                                    .characters
                                    .take(2)
                                    .string ??
                                '',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.userMetadata?['name']),
                            Text(user.email ?? ''),
                          ],
                        ),
                        Spacer(),
                        Icon(CupertinoIcons.right_chevron, size: 20),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Other settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).cardColor.withAlpha(100),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (ctx) => MyAccountScreens(user: user),
                            ),
                          );
                        },
                        title: Text('Edit Profile'),
                        trailing: Icon(CupertinoIcons.right_chevron),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (ctx) => ForgotPassword(),
                            ),
                          );
                        },
                        title: Text('Forgot Password'),
                        trailing: Icon(CupertinoIcons.right_chevron),
                      ),
                      ListTile(
                        title: Text('Dark Mode'),
                        trailing: Switch(
                          trackColor: WidgetStatePropertyAll(
                            Theme.of(context).cardColor,
                          ),
                          activeColor: Theme.of(
                            context,
                          ).scaffoldBackgroundColor,
                          thumbIcon: WidgetStatePropertyAll(
                            Icon(
                              themeMode == ThemeMode.dark
                                  ? Icons.bedtime
                                  : Icons.sunny,
                              color: whiteColor,
                            ),
                          ),
                          value: themeMode == ThemeMode.dark,
                          onChanged: (isDark) {
                            context.read<ThemeCubit>().toggleTheme(isDark);
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                'Are you sure you want to delete your account?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<UpdateAccountBloc>().add(
                                      DeleteAccountEvent(userId: user.id),
                                    );
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        selectedColor: Colors.red,
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        style: ListTileStyle.list,
                        leading: Icon(Icons.delete),
                        title: Text('Delete Account'),
                        trailing: Icon(CupertinoIcons.right_chevron),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
