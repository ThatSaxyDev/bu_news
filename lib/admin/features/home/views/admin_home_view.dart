import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class AdminHomeView extends ConsumerWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardDimension = 150.w;
    final iconSize = 50.w;
    final currentTheme = ref.watch(themeNotifierProvider);

    void navigateToType(BuildContext context, String type) {
      Routemaster.of(context).push('/add-post/$type');
    }

    void toggleTheme(WidgetRef ref) {
      ref.read(themeNotifierProvider.notifier).toggleTheme();
    }

    void navigateToCreateCommunity(BuildContext context) {
      Routemaster.of(context).push('/create-community');
    }

    return Scaffold(
      // backgroundColor: currentTheme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>  navigateToCreateCommunity(context),
      ),
      body: Container(
        height: height(context),
        width: width(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => navigateToType(context, 'image'),
              child: SizedBox(
                height: cardDimension,
                width: cardDimension,
                child: Card(
                  color: currentTheme.cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      PhosphorIcons.image,
                      size: iconSize,
                      color: currentTheme.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => navigateToType(context, 'text'),
              child: SizedBox(
                height: cardDimension,
                width: cardDimension,
                child: Card(
                  color: currentTheme.cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      PhosphorIcons.textAa,
                      size: iconSize,
                      color: currentTheme.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
