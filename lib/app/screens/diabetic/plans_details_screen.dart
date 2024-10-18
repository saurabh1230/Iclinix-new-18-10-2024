import 'package:flutter/material.dart';
import 'package:iclinix/app/widget/custom_app_bar.dart';
import 'package:iclinix/app/widget/custom_button_widget.dart';
import 'package:iclinix/app/widget/custom_containers.dart';
import 'package:iclinix/utils/dimensions.dart';
import 'package:iclinix/utils/sizeboxes.dart';
import 'package:iclinix/utils/styles.dart';
import 'package:iclinix/utils/themes/light_theme.dart';

import '../../../data/models/response/plans_model.dart';

class PlansDetailsScreen extends StatelessWidget {
  final PlanModel? planModel;
  const PlansDetailsScreen({super.key, this.planModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: planModel!.planName.toString(),isBackButtonExist: true,),
      bottomNavigationBar: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor
            , // Set the background color
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor, // Shadow color
                offset: const Offset(0, 4), // Shadow offset (horizontal, vertical)
                blurRadius: 8, // Spread radius
                spreadRadius: 1, // Additional spread radius
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text('${planModel!.discount.toInt()}% off',
                        style: openSansRegular.copyWith(color: greenColor,fontSize: Dimensions.fontSize12),),
                        Text(
                          '₹ ${planModel!.price.toInt()}',
                          style: openSansSemiBold.copyWith(
                            fontSize: Dimensions.fontSize20,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),


                      ],
                    ),
                    sizedBoxW10(),
                    Text(
                      '₹ ${planModel!.sellingPrice.toInt()}',
                      style: openSansBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSize20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomButtonWidget(buttonText: 'Purchase Plan',onPressed: () {},
                color: Theme.of(context).primaryColor,),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              CustomDecoratedContainer(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tag Line:',style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14,),),
                      Text(planModel!.tagLine.toString(),style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14,
                      color: Theme.of(context).hintColor),),
                    ],
                  )),
              sizedBoxDefault(),
              CustomDecoratedContainer(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description:',style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14,),),
                      Text(planModel!.sortDesc.toString(),style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14,
                          color: Theme.of(context).hintColor),)
                    ],
                  )),
              sizedBoxDefault(),
              CustomDecoratedContainer(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Features:',style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14,),),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: planModel!.features.length,
                          itemBuilder: (_,i) {
                        return Text('• ${planModel!.features[i].featureName}',style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14,
                            color: Theme.of(context).hintColor),);
                      })
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
