import 'package:bu_news/features/auth/controller/auth_controller.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:bu_news/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CommunitySettingsView extends ConsumerWidget {
  final String name;
  const CommunitySettingsView({
    super.key,
    required this.name,
  });

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/com/$name/community-settings/$name/edit-community/$name');
  }

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/com/$name/community-settings/$name/add-mods/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        title: Text(
          'Community Settings',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: 20.padH,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(PhosphorIcons.userPlus),
              title: const Text('Add moderators'),
              onTap: () => navigateToAddMods(context),
            ),
            ListTile(
              leading: const Icon(PhosphorIcons.pen),
              title: const Text('Edit community'),
              onTap: () => navigateToEditCommunity(context),
            ),
          ],
        ),
      ),
    );
  }
}
