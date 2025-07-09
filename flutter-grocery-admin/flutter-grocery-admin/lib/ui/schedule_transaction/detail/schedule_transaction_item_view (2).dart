import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/schedule_detail.dart';
import 'package:provider/provider.dart';

class ScheduleTransactionItemView extends StatelessWidget {
  const ScheduleTransactionItemView({
    super.key,
    required this.scheduleDetail,
    this.animationController,
    this.animation,
    this.onTap,
  });

  final ScheduleDetail scheduleDetail;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
          onTap: onTap as void Function()?,
          child: _ItemWidget(
            scheduleTransaction: scheduleDetail,
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child,
              ));
        });
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.scheduleTransaction,
  });

  final ScheduleDetail scheduleTransaction;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    double? balancePrice;
    String? attributeName;
    const Widget dividerWidget = Divider(
      height: PsDimens.space2,
    );

    // if (transaction.productAttributeName != null &&
    //     transaction.productAttributeName != '') {
    //   attributeName = transaction.productAttributeName.replaceAll('#', ',');
    // }
    if (scheduleTransaction.originalPrice != '0' && scheduleTransaction.discountAmount != '0') {
      balancePrice = (double.parse(scheduleTransaction.originalPrice!) -
              double.parse(scheduleTransaction.discountAmount!)) *
          double.parse(scheduleTransaction.qty!);
    } else {
      balancePrice = double.parse(scheduleTransaction.originalPrice!) *
          double.parse(scheduleTransaction.qty!);
    }
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  const Icon(
                    FontAwesome5.tag,
                  ),
                  const SizedBox(
                    width: PsDimens.space16,
                  ),
                  Expanded(
                    child: Text(
                      scheduleTransaction.productName ?? '-',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            dividerWidget,
            Row(
              children: <Widget>[
                if (scheduleTransaction.productColorCode != null &&
                    scheduleTransaction.productColorCode != '')
                  Container(
                    margin: const EdgeInsets.all(PsDimens.space10),
                    width: PsDimens.space32,
                    height: PsDimens.space32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Utils.hexToColor(scheduleTransaction.productColorCode),
                      // border: Border.all(width: 1, color: PsColors.grey),
                    ),
                  )
                else
                  Container(),
                if (attributeName != '')
                  Flexible(
                    child: Text(
                      attributeName! ,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                const SizedBox(
                  width: PsDimens.space16,
                ),
              ],
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${scheduleTransaction.currencySymbol}  ${Utils.getPriceFormat(scheduleTransaction.originalPrice!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__price')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: scheduleTransaction.discountAmount != null
                  ? ' ${scheduleTransaction.currencySymbol} ${Utils.getPriceFormat(scheduleTransaction.discountAmount.toString(), valueHolder)}'
                  : '${scheduleTransaction.currencySymbol} 0.0',
              title:
                  '${Utils.getString(context, 'transaction_detail__discount_avaiable_amount')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${scheduleTransaction.currencySymbol} ${Utils.getPriceFormat(scheduleTransaction.price.toString(), valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__balance')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: '${scheduleTransaction.qty}',
              title: '${Utils.getString(context, 'transaction_detail__qty')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  ' ${scheduleTransaction.currencySymbol} ${Utils.getPriceFormat(balancePrice.toString(), valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            ),
            const SizedBox(height: PsDimens.space12),
            _CustomizedAndAddOnTextWidget(
              infoText:
                  scheduleTransaction.productCustomizedName!.replaceAll('#', ', '),
              title:
                  '${Utils.getString(context, 'transaction_detail__customized')} :',
            ),
            _CustomizedAndAddOnTextWidget(
              infoText: scheduleTransaction.productAddonName!.replaceAll('#', ', '),
              title:
                  '${Utils.getString(context, 'transaction_detail__add_on')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
          ],
        ));
  }
}

class _CustomizedAndAddOnTextWidget extends StatelessWidget {
  const _CustomizedAndAddOnTextWidget(
      {required this.title, required this.infoText});

  final String title;
  final String infoText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Visibility(
            visible: infoText != '',
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Visibility(
            visible: infoText != '',
            child: Container(
              margin: const EdgeInsets.all(PsDimens.space12),
              child: Text(
                infoText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TransactionNoTextWidget extends StatelessWidget {
  const _TransactionNoTextWidget({
    required this.transationInfoText,
    this.title,
  });

  final String transationInfoText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          top: PsDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            transationInfoText,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
