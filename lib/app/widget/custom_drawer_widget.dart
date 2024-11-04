

import 'package:flutter/material.dart';
import 'package:iclinix/app/screens/dashboard/dashboard_screen.dart';
import 'package:iclinix/app/widget/confirmation_dialog.dart';
import 'package:iclinix/app/widget/custom_image_widget.dart';
import 'package:iclinix/controller/auth_controller.dart';
import 'package:iclinix/controller/profile_controller.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/images.dart';
import 'package:iclinix/utils/sizeboxes.dart';
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
        GetBuilder<AuthController>(builder: (controller) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const DashboardScreen(pageIndex: 4));
                        },
                        child: Container(padding: const EdgeInsets.all(Dimensions.paddingSize10),
                          height: 70,width: 70,clipBehavior: Clip.hardEdge,
                          decoration:  const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          child: Image.asset(Images.icProfilePlaceholder,
                            height: 60,width: 60,fit: BoxFit.cover,),
                        ),
                      ),
                      sizedBox10(),
                      Text(
                        controller.userData != null
                            ? '${controller.userData!.firstName}\n${controller.userData!.lastName}'
                            : 'Iclinix',
                        textAlign: TextAlign.center,
                        style: openSansSemiBold.copyWith(fontSize: Dimensions.fontSize30,

                        color: Colors.white),
                      ),

                    ],
                  ),
                  // Image.network(height: 80,width: 80,
                  //     controller.userData!.image.toString()),
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
            const SizedBox(height: 20),
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
                    "Appointment",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18,color: Theme.of(context).cardColor)
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
                onPressed: () {
                  Get.toNamed(RouteHelper.getHelpRoute());
                },
                child: Text(
                    "Contact Us",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18,color: Theme.of(context).cardColor)
                ),
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                    "Privacy Policy",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18,color: Theme.of(context).cardColor)
                ),
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                    "Terms & Condition",
                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18,color: Theme.of(context).cardColor)
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Get.dialog(
                    ConfirmationDialog(
                      icon: Images.icLogout,
                      description: 'Are You Sure To Logout',
                      onYesPressed: () {
                       Get.toNamed(RouteHelper.getLoginRoute());
                      },
                    ),
                  );
                },
                child: Text(
                  "Log Out",
                  style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18, color: Theme.of(context).cardColor),
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
    super.key,
    required this.menu,
    this.padding = const EdgeInsets.all(10),
    this.icon,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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