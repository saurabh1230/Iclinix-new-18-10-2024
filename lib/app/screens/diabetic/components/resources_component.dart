import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iclinix/controller/diabetic_controller.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesComponent extends StatelessWidget {
  const ResourcesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiabeticController>(builder: (controller) {
      final data = controller.planDetails?.planResources ?? []; // Safely access planResources
      final isListEmpty = data.isEmpty;
      final isSugarLoading = controller.isDailySugarCheckupLoading;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resources',
            style: openSansSemiBold,
          ),
          sizedBox10(),
          Text(
            'Video Content',
            style: openSansRegular.copyWith(
              fontSize: Dimensions.fontSize14,
              color: Theme.of(context).disabledColor.withOpacity(0.60),
            ),
          ),
          sizedBoxDefault(),
          if (isSugarLoading)
            const Center(child: CircularProgressIndicator()) // Show loading indicator
          else if (isListEmpty)
            const Center(child: Text('No resources available')) // Show no resources text
          else
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: data.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return Container(
                    height: 200,
                    width: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8), // Optional: Add some rounding
                      boxShadow: [],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('checl');
                                _launchURL(data[i].ytUrl.toString());
                              },
                              child: Image.asset(
                                'assets/images/doctor_demo_pic.png',
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.play_circle_fill_outlined,
                                size: 60,
                                color: Colors.redAccent.withOpacity(0.80),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          data[i].name.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: openSansMedium.copyWith(
                            fontSize: Dimensions.fontSize13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => sizedBoxW10(),
              ),
            ),
          Text(
            'Reading Content',
            style: openSansRegular.copyWith(
              fontSize: Dimensions.fontSize14,
              color: Theme.of(context).disabledColor.withOpacity(0.60),
            ),
          ),
          sizedBoxDefault(),
          SizedBox(
            height: 300,
            child: ListView.separated(
              itemCount: 4,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                return Container(
                  height: 200,
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8), // Optional: Add some rounding
                    boxShadow: [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/ic_reading.png',
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amt, consectetur Lorem ipsum dolor sit amt, consectetur',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: openSansMedium.copyWith(
                          fontSize: Dimensions.fontSize13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Download',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: openSansBold.copyWith(
                            fontSize: Dimensions.fontSize14,
                            decoration: TextDecoration.underline,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => sizedBoxW10(),
            ),
          ),
        ],
      );
    });
  }
  // Method to launch the URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
