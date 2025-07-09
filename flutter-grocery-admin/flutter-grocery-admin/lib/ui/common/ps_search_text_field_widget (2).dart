import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/product_parameter_holder.dart';

class PsSearchTextFieldWidget extends StatelessWidget {
  const PsSearchTextFieldWidget(
      {super.key, this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.psValueHolder
      });

  final TextEditingController? textEditingController;
  final String? hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder? psValueHolder;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final ProductParameterHolder productParameterHolder =
        ProductParameterHolder().getLatestParameterHolder();
    final Widget productTextFieldWidget = TextField(
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: PsDimens.space12,
          bottom: PsDimens.space12,
        ),
        border: InputBorder.none,
        hintText: hintText,
      ),
      onSubmitted: (String value) {
        productParameterHolder.searchTerm = textEditingController!.text;
        Navigator.pushNamed(
            context, RoutePaths.searchItemList,
            arguments: productParameterHolder);
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
              color: PsColors.mainDividerColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
          child: productTextFieldWidget,
        ),
      ],
    );
  }
}