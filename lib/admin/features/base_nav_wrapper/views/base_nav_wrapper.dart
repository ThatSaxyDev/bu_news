import 'package:bu_news/admin/features/approval/views/application_approval_view.dart';
import 'package:bu_news/admin/features/base_nav_wrapper/widgets/nav_bar_item.dart';
import 'package:bu_news/admin/features/home/views/admin_home_view.dart';
import 'package:bu_news/admin/features/verifications/views/verification_view.dart';
import 'package:bu_news/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AdminBaseNavWrapper extends ConsumerStatefulWidget {
  const AdminBaseNavWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminBaseNavWrapperState();
}

class _AdminBaseNavWrapperState extends ConsumerState<AdminBaseNavWrapper> {
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  List<Widget> pages = [
    AdminHomeView(),
    ApplicationsApproval(),
    VerificationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ValueListenableBuilder(
              valueListenable: selectedIndex,
              child: const SizedBox.shrink(),
              builder: (context, value, child) {
                return NavigationRail(
                  selectedIndex: selectedIndex.value,
                  onDestinationSelected: (value) {
                    selectedIndex.value = value;
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(PhosphorIcons.house),
                      selectedIcon: Icon(PhosphorIcons.houseFill),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(PhosphorIcons.wrench),
                      selectedIcon: Icon(PhosphorIcons.wrenchFill),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(PhosphorIcons.gear),
                      selectedIcon: Icon(PhosphorIcons.gearFill),
                      label: Text('Home'),
                    ),
                  ],
                );
              }),
          // const VerticalDivider(
          //   width: 1.5,
          //   color: Pallete.greyColor,
          // ),

          //! main body
          ValueListenableBuilder(
            valueListenable: selectedIndex,
            child: const SizedBox.shrink(),
            builder: (context, value, child) {
              return Expanded(
                child: pages[selectedIndex.value],
              );
            },
          ),
        ],
      ),
    );
  }
}
