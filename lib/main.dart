import 'package:chat_app/core/secrets/secrets.dart';
import 'package:chat_app/core/theme/theme_cubit.dart';
import 'package:chat_app/feature/auth/data/data_sources/remote_data_sources/supabase_auth_data_source.dart';
import 'package:chat_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:chat_app/feature/auth/domain/use_cases/create_account_use_case.dart';
import 'package:chat_app/feature/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:chat_app/feature/auth/domain/use_cases/sigin_in_use_case.dart';
import 'package:chat_app/feature/auth/presentation/blocs/bloc/auth_bloc.dart';
import 'package:chat_app/feature/auth/presentation/screens/welcome_screen.dart';
import 'package:chat_app/feature/home/data/data_sources/remote_data_sources/supabase_chat_data_source.dart';
import 'package:chat_app/feature/home/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/feature/home/domain/use_cases/send_message_use_case.dart';
import 'package:chat_app/feature/home/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/feature/home/presentation/screens/home_screen.dart';
import 'package:chat_app/feature/profile/data/data_sources/remote_data_sources/supabase_account_data_source.dart';
import 'package:chat_app/feature/profile/data/repositories/update_account_repository_impl.dart';
import 'package:chat_app/feature/profile/domain/use_cases/delete_account_use_case.dart';
import 'package:chat_app/feature/profile/domain/use_cases/update_account_use_case.dart';
import 'package:chat_app/feature/profile/presentation/bloc/update_account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'core/theme/pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://idlpselnydceqtxwmyvg.supabase.co',
    anonKey: AppSecrets.dbKey,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => ThemeCubit()),
        BlocProvider(
          create: (context) => AuthBloc(
            CreateAccountUseCase(
              repository: AuthRepositoryImpl(
                dataSource: SupabaseAuthDataSource(
                  supabase: Supabase.instance.client,
                ),
              ),
            ),
            SiginInUseCase(
              repository: AuthRepositoryImpl(
                dataSource: SupabaseAuthDataSource(
                  supabase: Supabase.instance.client,
                ),
              ),
            ),
            ForgotPasswordUseCase(
              repository: AuthRepositoryImpl(
                dataSource: SupabaseAuthDataSource(
                  supabase: Supabase.instance.client,
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (ctx) => ChatBloc(
            SendMessageUseCase(
              repository: ChatRepositoryImpl(
                dataSource: SupabaseChatDataSource(
                  supabase: Supabase.instance.client,
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (ctx) => UpdateAccountBloc(
            UpdateAccountUseCase(
              repository: UpdateAccountRepositoryImpl(
                dataSource: SupabaseAccountDataSource(
                  supabase: Supabase.instance.client,
                ),
              ),
            ),
            DeleteAccountUseCase(
              repository: UpdateAccountRepositoryImpl(
                dataSource: SupabaseAccountDataSource(
                  supabase: Supabase.instance.client,
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
    final supabase = Supabase.instance.client;
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
                stream: supabase.auth.onAuthStateChange,
                builder: (ctx, snapshot) {
                  final session = supabase.auth.currentUser;
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
