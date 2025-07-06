import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/provider/delivery_boy_rating/delivery_boy_rating_provider.dart';
import 'package:fluttermultigrocery/provider/transaction/transaction_detail_provider.dart';
import 'package:fluttermultigrocery/repository/delivery_boy_rating_repository.dart';
import 'package:fluttermultigrocery/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultigrocery/ui/common/ps_button_widget.dart';
import 'package:fluttermultigrocery/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultigrocery/ui/common/smooth_star_rating_widget.dart';
import 'package:fluttermultigrocery/utils/ps_progress_dialog.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/delivery_boy_rating.dart';
import 'package:fluttermultigrocery/viewobject/holder/delivery_boy_rating_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/transaction_header.dart';
import 'package:provider/provider.dart';

class DeliveryBoyRatingInputDialog extends StatefulWidget {
  const DeliveryBoyRatingInputDialog(
      {super.key, 
      required this.transactionHeader,
      required this.transactionDetailProvider,
    });

  final TransactionHeader transactionHeader;
  final TransactionDetailProvider transactionDetailProvider;

  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<DeliveryBoyRatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double? rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    final DeliveryBoyRatingRepository ratingRepo = 
        Provider.of<DeliveryBoyRatingRepository>(context);

    final Widget headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space12),
            Icon(
              Icons.rate_review,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space8),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));
    return ChangeNotifierProvider<DeliveryBoyRatingProvider>(
        lazy: false,
        create: (BuildContext context) {
          final DeliveryBoyRatingProvider provider = DeliveryBoyRatingProvider(
            repo: ratingRepo,
            psValueHolder: valueHolder);
     
          return provider;
        },
        child: Consumer<DeliveryBoyRatingProvider>(builder:
            (BuildContext context, DeliveryBoyRatingProvider provider, Widget? child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  headerWidget,
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Utils.getString(context, 'rating_entry__your_rating'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      ),
                      if (rating == null)
                        SmoothStarRating(
                            isRTl:
                                Directionality.of(context) == TextDirection.rtl,
                            allowHalfRating: false,
                            rating: 0.0,
                            starCount: 5,
                            size: PsDimens.space24,
                            color: PsColors.ratingColor,
                            onRated: (double? rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0)
                      else
                        SmoothStarRating(
                            isRTl:
                                Directionality.of(context) == TextDirection.rtl,
                            allowHalfRating: false,
                            rating: rating!,
                            starCount: 5,
                            size: PsDimens.space24,
                            color: PsColors.ratingColor,
                            onRated: (double? rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0),
                      PsTextFieldWidget(
                          titleText:
                              Utils.getString(context, 'rating_entry__title'),
                          hintText:
                              Utils.getString(context, 'rating_entry__title'),
                          textEditingController: titleController),
                      PsTextFieldWidget(
                          height: PsDimens.space120,
                          titleText:
                              Utils.getString(context, 'rating_entry__message'),
                          hintText:
                              Utils.getString(context, 'rating_entry__message'),
                          textEditingController: descriptionController),
                      const Divider(
                        height: 0.5,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _ButtonWidget(
                        descriptionController: descriptionController,
                        provider: provider,
                        transactionDetailProvider: widget.transactionDetailProvider,
                        transactionHeader: widget.transactionHeader,
                        titleController: titleController,
                        rating: rating,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget(
      {required this.titleController,
      required this.descriptionController,
      required this.provider,
      required this.transactionDetailProvider,
      required this.transactionHeader,

      required this.rating});

  final TextEditingController titleController, descriptionController;
  final DeliveryBoyRatingProvider provider;
  final TransactionDetailProvider transactionDetailProvider;
  final TransactionHeader transactionHeader;
  final double ?rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: false,
                colorData: PsColors.grey,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__submit'),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      rating != null &&
                      rating.toString() != '0.0') {
                    final DeliveryBoyRatingParameterHolder ratingParameterHolder =
                        DeliveryBoyRatingParameterHolder(
                            transactionHeaderId: transactionHeader.id,
                            rating: rating.toString(),
                            title: titleController.text,
                            description: descriptionController.text);

                    await PsProgressDialog.showDialog(context);

                    final PsResource<DeliveryBoyRating> deliveryBoyRating = await 
                        provider.postDeliveryBoyRating(ratingParameterHolder.toMap());

                    if(deliveryBoyRating.data != null) {
                      PsProgressDialog.dismissDialog();
                      Navigator.pop(context);
                      transactionHeader.ratingStatus = deliveryBoyRating.data!.transactionHeader!.ratingStatus;
                      transactionDetailProvider
                        .resetTransactionDetailList(transactionHeader);
                    } else {
                        PsProgressDialog.dismissDialog();
                        Navigator.pop(context);
                        showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                            onPressed: () {},
                          );
                        });
                    } 
                  } else {
                    print('There is no comment');
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                            onPressed: () {},
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
