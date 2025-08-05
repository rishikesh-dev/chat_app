import 'package:chat_app/core/theme/theme_cubit.dart';
import 'package:chat_app/feature/auth/data/data_sources/remote_data_sources/remote_auth_data_source.dart';
import 'package:chat_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/feature/auth/domain/use_cases/create_account_use_case.dart';
import 'package:chat_app/feature/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:chat_app/feature/auth/domain/use_cases/sigin_in_use_case.dart';
import 'package:chat_app/feature/auth/presentation/blocs/bloc/auth_bloc.dart';
import 'package:chat_app/feature/auth/presentation/screens/welcome_screen.dart';
import 'package:chat_app/feature/home/data/data_sources/remote_data_sources/remote_chat_data_source.dart';
import 'package:chat_app/feature/home/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/feature/home/domain/use_cases/send_message_use_case.dart';
import 'package:chat_app/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/feature/home/presentation/screens/home_screen.dart';
import 'package:chat_app/feature/profile/data/data_sources/remote_data_sources/remote_account_data_source.dart';
import 'package:chat_app/feature/profile/data/repositories/update_account_repository_impl.dart';
import 'package:chat_app/feature/profile/domain/use_cases/delete_account_use_case.dart';
import 'package:chat_app/feature/profile/domain/use_cases/update_account_use_case.dart';
import 'package:chat_app/feature/profile/presentation/bloc/update_account_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:toastification/toastification.dart';
import 'core/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => ThemeCubit()),
        BlocProvider(
          create: (context) => AuthBloc(
            CreateAccountUseCase(
              repository: AuthRepositoryImpl(
                dataSource: RemoteAuthDataSource(auth: FirebaseAuth.instance),
              ),
            ),
            SiginInUseCase(
              repository: AuthRepositoryImpl(
                dataSource: RemoteAuthDataSource(auth: FirebaseAuth.instance),
              ),
            ),
            ForgotPasswordUseCase(
              repository: AuthRepositoryImpl(
                dataSource: RemoteAuthDataSource(auth: FirebaseAuth.instance),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (ctx) => ChatBloc(
            SendMessageUseCase(
              repository: ChatRepositoryImpl(
                dataSource: RemoteChatDataSource(
                  auth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (ctx) => UpdateAccountBloc(
            UpdateAccountUseCase(
              repository: UpdateAccountRepositoryImpl(
                dataSource: RemoteAccountDataSource(
                  auth: FirebaseAuth.instance,
                ),
              ),
            ),
            DeleteAccountUseCase(
              repository: UpdateAccountRepositoryImpl(
                dataSource: RemoteAccountDataSource(
                  auth: FirebaseAuth.instance,
                ),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return KeyboardEmojiPickerWrapper(
      child: ToastificationWrapper(
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chat App',
              theme: Pallete.lightTheme,
              darkTheme: Pallete.darkTheme,
              themeMode: themeMode,
              home: StreamBuilder(
                stream: auth.authStateChanges(),
                builder: (ctx, snapshot) {
                  final session = auth.currentUser;
                  if (session != null) {
                    return HomeScreen();
                  } else {
                    return WelcomeScreen();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
