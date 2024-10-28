import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).cardColor,
        height: Get.size.height,
        width: Get.size.width,
        child: Center(
          child: Lottie.asset('assets/icons/ic_loader_lottie.json',height: 160,width: 160),
        ),
      ),
    );
  }
}
