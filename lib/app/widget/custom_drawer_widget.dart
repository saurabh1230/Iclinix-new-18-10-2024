import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/dashboard/dashboard_screen.dart';
import 'package:iclinix/controller/profile_controller.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Widget _thumbnailPart() {
    return Row(
      children: [
        // SizedBox(
        //   width: 50,
        //   height: 50,
        //   child: CircleAvatar(
        //     backgroundImage:
        //     Image.asset("assets/default_user.png", fit: BoxFit.contain)
        //         .image,
        //   ),
        // ),
        GetBuilder<ProfileController>(builder: (controller) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    controller.userData != null
                        ? '${controller.userData!.firstName}\n${controller.userData!.lastName}'
                        : 'Iclinix',
                    style: openSansSemiBold.copyWith(fontSize: Dimensions.fontSize30,
                    color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        })

      ],
    );
  }

  Widget get _line => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 1,
      color: Colors.white.withOpacity(0.2));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _thumbnailPart(),
            SizedBox(height: 20),
            _line,
            // TextButton(
            //   onPressed: () {  },
            //   child: Text(
            //     "Records",
            //     style: openSansRegular.copyWith(fontSize: Dimensions.fontSize28,color: Theme.of(context).cardColor)
            //   ),
            // ),
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const DashboardScreen(pageIndex: 3));
                },
                child: Text(
                    "History",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize28,color: Theme.of(context).cardColor)
                ),
              ),
            ),
            // Align(alignment: Alignment.centerLeft,
            //   child: TextButton(
            //     onPressed: () {
            //       Get.to(() => const DashboardScreen(pageIndex: 4));
            //     },
            //     child: Text(
            //         "Profile",
            //         style: openSansRegular.copyWith(fontSize: Dimensions.fontSize28,color: Theme.of(context).cardColor)
            //     ),
            //   ),
            // ),
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {  },
                child: Text(
                    "Help",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize28,color: Theme.of(context).cardColor)
                ),
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                    "Privacy Policy",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize28,color: Theme.of(context).cardColor)
                ),
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                    "Terms & Condition",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize28,color: Theme.of(context).cardColor)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuBox extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Widget menu;
  final Function()? onTap;
  const MenuBox({
    Key? key,
    required this.menu,
    this.padding = const EdgeInsets.all(10),
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          this.onTap!();
        }
      },
      child: Container(
        padding: padding,
        child: Row(
          children: [
            icon != null ? icon! : Container(),
            const SizedBox(width: 15),
            menu,
          ],
        ),
      ),
    );
  }
}