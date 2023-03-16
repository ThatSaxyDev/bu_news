import 'package:bu_news/admin/features/auth/controller/admin_auth_controller.dart';
import 'package:bu_news/admin/models/admin_model.dart';
import 'package:bu_news/admin/router/admin_router.dart';
import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/firebase_options.dart';
import 'package:bu_news/models/user_model.dart';
import 'package:bu_news/router.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/error_text.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    runApp(
      const ProviderScope(
        child: AdminWebApp(),
      ),
    );
  } else {
    runApp(
      const ProviderScope(
        child: UserMobileApp(),
      ),
    );
  }
}

class UserMobileApp extends ConsumerStatefulWidget {
  const UserMobileApp({super.key});

  @override
  ConsumerState<UserMobileApp> createState() => _UserMobileAppState();
}

class _UserMobileAppState extends ConsumerState<UserMobileApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: false,
              builder: (context, child) {
                return Builder(builder: (context) {
                  return MaterialApp.router(
                    title: 'BU News',
                    debugShowCheckedModeBanner: false,
                    theme: ref.watch(themeNotifierProvider),
                    routerDelegate:
                        RoutemasterDelegate(routesBuilder: (context) {
                      if (data != null) {
                        getData(ref, data);
                        if (userModel != null) {
                          return loggedInRoute;
                        }
                      }
                      return loggedOutRoute;
                    }),
                    routeInformationParser: const RoutemasterParser(),
                  );
                });
              }),
          error: (error, stactrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}

class AdminWebApp extends ConsumerStatefulWidget {
  const AdminWebApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminWebAppState();
}

class _AdminWebAppState extends ConsumerState<AdminWebApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(adminAuthStateChangeProvider).when(
          data: (data) => ScreenUtilInit(
              designSize: const Size(1512, 982),
              minTextAdapt: true,
              splitScreenMode: false,
              builder: (context, child) {
                return MaterialApp.router(
                  title: 'BU news admin',
                  debugShowCheckedModeBanner: false,
                  theme: ref.watch(themeNotifierProvider),
                  routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                    if (data != null) {
                      getData(ref, data);
                      if (userModel != null) {
                        return adminLoggedInRoute;
                      }
                    }
                    return adminLoggedOutRoute;
                  }),
                  routeInformationParser: const RoutemasterParser(),
                );
              }),
          error: (error, stactrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
