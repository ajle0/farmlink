import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/transaction_header.dart';
import 'package:provider/provider.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.animationController,
    this.animation,
    this.onTap,
    @required this.scaffoldKey,
  });

  final TransactionHeader transaction;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    if (transaction.transCode != null) {
      return AnimatedBuilder(
          animation: animationController!,
          child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Container(
              color: PsColors.backgroundColor,
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _TransactionNoWidget(
                    transaction: transaction,
                    scaffoldKey: scaffoldKey!,
                  ),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  _TransactionTextWidget(
                    transaction: transaction,
                  ),
                  const SizedBox(
                    height: PsDimens.space16,
                  )
                ],
              ),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: animation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child,
              ),
            );
          });
    } else {
      return Container();
    }
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    required this.transaction,
    required this.scaffoldKey,
  });

  final TransactionHeader transaction;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final Widget textWidget = Text(
      '${Utils.getString(context, 'transaction_detail__trans_no')} : ${transaction.transCode}',
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.titleMedium,
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space4,
          top: PsDimens.space4,
          bottom: PsDimens.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.offline_pin,
                size: 24,
              ),
              const SizedBox(
                width: PsDimens.space8,
              ),
              textWidget,
            ],
          ),
          IconButton(
            icon: const Icon(Icons.content_copy),
            iconSize: 24,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: transaction.transCode ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).iconTheme.color,
                content: Tooltip(
                  message: Utils.getString(context, 'transaction_detail__copy'),
                  showDuration: const Duration(seconds: 5),
                  child: Text(
                    Utils.getString(context, 'transaction_detail__copied_data'),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: PsColors.mainColor),
                  ),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionTextWidget extends StatelessWidget {
  const _TransactionTextWidget({
    required this.transaction,
  });

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    const EdgeInsets paddingEdgeInsetWidget = EdgeInsets.only(
      left: PsDimens.space16,
      right: PsDimens.space16,
      top: PsDimens.space8,
    );

    final Widget totalAmountTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_list__total_amount'),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.balanceAmount!, valueHolder)}',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: PsColors.mainColor, fontWeight: FontWeight.normal),
        )
      ],
    );

    final Widget statusTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_detail__status'),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
              top: PsDimens.space4,
              bottom: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          decoration: BoxDecoration(
              color: Utils.hexToColor(transaction.transStatus!.colorValue),
              // border: Border.all(color: PsColors.mainLightShadowColor),
              borderRadius:
                  const BorderRadius.all(Radius.circular(PsDimens.space8))),
          child: Text(
            transaction.transStatus!.title ?? '-',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: PsColors.black),
          ),
        )
      ],
    );

    final Widget viewDetailTextWidget = Text(
      Utils.getString(context, 'transaction_detail__view_details'),
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline,
          ),
    );
    if (transaction.transCode != null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: paddingEdgeInsetWidget,
            child: totalAmountTextWidget,
          ),
          Padding(
            padding: paddingEdgeInsetWidget,
            child: statusTextWidget,
          ),
          Padding(
            padding: paddingEdgeInsetWidget,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                viewDetailTextWidget,
              ],
            ),
          ),
          const SizedBox(
            height: PsDimens.space8,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
