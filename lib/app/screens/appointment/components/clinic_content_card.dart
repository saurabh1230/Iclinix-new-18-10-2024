import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_card_container.dart';
import 'package:iclinix/app/widget/custom_image_widget.dart';
import 'package:iclinix/app/widget/empty_data_widget.dart';
import 'package:iclinix/controller/clinic_controller.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/images.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iclinix/utils/themes/light_theme.dart';

class ClinicContentCard extends StatelessWidget {
  const ClinicContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ClinicController>().getClinicList();
    });
    return GetBuilder<ClinicController>(builder: (clinicControl) {
      final dataList = clinicControl.clinicList;
      final isListEmpty = dataList == null || dataList.isEmpty;
      final isLoading = clinicControl.isClinicLoading;
      return isListEmpty && !isLoading
          ? Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSize100),
        child: Center(
            child: EmptyDataWidget(
              text: 'Nothing Available',
              image: Images.icEmptyDataHolder,
              fontColor: Theme.of(context).disabledColor,
            )),
      )
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          :
        ListView.separated(
        itemCount: dataList!.length,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_,i) {
          return CustomCardContainer(
            radius: Dimensions.radius5,
            tap: () {
              Get.toNamed(
                RouteHelper.getSelectSlotRoute(),
                arguments: dataList[i], // Pass the clinicModel as an argument
              );
            },
            child: Column(
              children: [
                CustomNetworkImageWidget(
                  height: 200,
                  image: dataList[i].image,),
                sizedBox4(),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSize10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataList[i].branchName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: openSansBold.copyWith(fontSize: Dimensions.fontSize14),
                      ),
                      sizedBox4(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Branch Contact: ",
                              style: openSansRegular.copyWith(
                                  fontSize: Dimensions.fontSize12,
                                  color: Theme.of(context).primaryColor), // Different color for "resend"
                            ),
                            TextSpan(
                              text: dataList[i].branchContactNo,
                              style: openSansRegular.copyWith(
                                  fontSize: Dimensions.fontSize13,
                                  color: Theme.of(context)
                                      .hintColor), // Different color for "resend"
                            ),
                          ],
                        ),
                      ),
                      sizedBox4(),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '4.8',
                                style: openSansRegular.copyWith(
                                    fontSize: Dimensions.fontSize14,
                                    color: Theme.of(context).hintColor),
                              ),
                              RatingBar.builder(
                                itemSize:  Dimensions.fontSize14,
                                initialRating: 4,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: Dimensions.fontSize14,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Open: ",
                                    style: openSansRegular.copyWith(
                                        fontSize: Dimensions.fontSize12,
                                        color: greenColor), // Different color for "resend"
                                  ),
                                  TextSpan(
                                    text: "10AM-7PM",
                                    style: openSansRegular.copyWith(
                                        fontSize: Dimensions.fontSize13,
                                        color: Theme.of(context)
                                            .hintColor), // Different color for "resend"
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSize12,left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault),
                  child: CustomButtonWidget(height: 40, buttonText: 'Book Appointment',
                  transparent: true,isBold: false,
                  fontSize: Dimensions.fontSize14,
                  onPressed: () {
                    Get.toNamed(
                      RouteHelper.getSelectSlotRoute(),
                      arguments: dataList[i], // Pass the clinicModel as an argument
                    );
                  },),
                ),
              ],
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) => sizedBoxDefault(),);
    });
  }
}
