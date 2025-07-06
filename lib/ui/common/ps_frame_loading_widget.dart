import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';

class PsFrameUIForLoading extends StatelessWidget {
  const PsFrameUIForLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(PsDimens.space16),
        decoration: BoxDecoration(color: PsColors.grey));
  }
}
