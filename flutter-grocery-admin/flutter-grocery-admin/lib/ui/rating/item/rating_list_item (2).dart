import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/common/smooth_star_rating_widget.dart';
import 'package:fluttermultigrocery/viewobject/rating.dart';

class RatingListItem extends StatelessWidget {
  const RatingListItem({
    super.key,
    required this.rating,
    this.onTap,
  });

  final Rating rating;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _RatingListDataWidget(
              rating: rating,
            ),
            const Divider(
              height: PsDimens.space1,
            ),
            ImageAndTextWidget(
              rating: rating,
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingListDataWidget extends StatelessWidget {
  const _RatingListDataWidget({
    required this.rating,
  });

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final Widget ratingStarsWidget = SmoothStarRating(
        key: Key(rating.rating!),
        rating: double.parse(rating.rating!),
        isReadOnly: true,
        allowHalfRating: false,
        starCount: 5,
        size: PsDimens.space16,
        color: PsColors.ratingColor,
        borderColor: PsColors.grey.withAlpha(100),
        spacing: 0.0);

    const Widget spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    final Widget titleTextWidget = Text(
      rating.title!,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
    final Widget descriptionTextWidget = Text(
      rating.description!,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ratingStarsWidget,
          spacingWidget,
          titleTextWidget,
          spacingWidget,
          descriptionTextWidget,
        ],
      ),
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    super.key,
    required this.rating,
  });

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(PsDimens.space8),
      child: SizedBox(
        width: PsDimens.space40,
        height: PsDimens.space40,
        child: PsNetworkImageWithUrl(
          photoKey: '',
          imagePath: rating.user!.userProfilePhoto!,
        ),
      ),
    );
    final Widget personNameTextWidget = Text(rating.user!.userName!,
        style: Theme.of(context).textTheme.titleLarge!.copyWith());

    final Widget timeWidget = Text(
      rating.addedDateStr!,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              imageWidget,
              const SizedBox(
                width: PsDimens.space12,
              ),
              personNameTextWidget,
            ],
          ),
          timeWidget,
        ],
      ),
    );
  }
}
