import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:provider/provider.dart';

class HistoryListItem extends StatelessWidget {
  const HistoryListItem(
      {super.key,
      required this.history,
      this.onTap,
      this.animationController,
      this.animation});

  final Product history;
  final Function? onTap;
  final AnimationController ?animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (history != null) {
      animationController!.forward();
      return AnimatedBuilder(
          animation: animationController!,
          child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Container(
              margin: const EdgeInsets.only(top: PsDimens.space8),
              color: PsColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _ImageAndTextWidget(
                  history: history,
                ),
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
                ));
          });
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    required this.history,
  });

  final Product history;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = 
        Provider.of<PsValueHolder>(context, listen: false);

    if ( history.name != null) {
      return Row(
        children: <Widget>[
          SizedBox(
            width: PsDimens.space60,
            height: PsDimens.space60,
            child: PsNetworkImage(
              photoKey: '',
              // width: PsDimens.space60,
              // height: PsDimens.space60,
              defaultPhoto: history.defaultPhoto!,
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Text(
                    history.name!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Text(
                  history.addedDate == ''
                      ? ''
                      : Utils.getDateFormat(history.addedDate!, psValueHolder),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
