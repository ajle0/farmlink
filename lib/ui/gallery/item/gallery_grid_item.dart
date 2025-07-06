import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/viewobject/default_photo.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    super.key,
    required this.image,
    this.onImageTap,
  });

  final DefaultPhoto? image;
  final Function? onImageTap;

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: image!,
      width: MediaQuery.of(context).size.width,
      height: PsDimens.space200,
      boxfit: BoxFit.cover,
      onTap: onImageTap,
    );
    return Container(
      margin: const EdgeInsets.all(PsDimens.space4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PsDimens.space8),
        child: image != null ? imageWidget : null,
      ),
    );
  }
}
