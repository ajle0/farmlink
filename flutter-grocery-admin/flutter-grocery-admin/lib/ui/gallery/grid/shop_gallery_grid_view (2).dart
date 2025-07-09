import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/gallery/gallery_provider.dart';
import 'package:fluttermultigrocery/repository/gallery_repository.dart';
import 'package:fluttermultigrocery/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultigrocery/ui/gallery/item/gallery_grid_item.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/shop_info.dart';
import 'package:provider/provider.dart';

class ShopGalleryGridView extends StatefulWidget {
  const ShopGalleryGridView({
    super.key,
    required this.shopInfo,
    this.onImageTap,
  });

  final ShopInfo shopInfo;
  final Function? onImageTap;
  @override
  _ShopGalleryGridViewState createState() => _ShopGalleryGridViewState();
}

class _ShopGalleryGridViewState extends State<ShopGalleryGridView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    final GalleryRepository shopGalleryRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
        appBarTitle: Utils.getString(context, 'gallery__title') ,
        initProvider: () {
          return GalleryProvider(
            repo: shopGalleryRepo,
            psValueHolder: valueHolder);
        },
        onProviderReady: (GalleryProvider provider) {
          provider.loadImageList(
            widget.shopInfo.defaultPhoto!.imgParentId!,
          );
        },
        builder:
            (BuildContext context, GalleryProvider provider, Widget? child) {
          if (
            //provider.galleryList != null &&
              provider.galleryList.data!.isNotEmpty) {
            return Container(
              color: Theme.of(context).cardColor,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150, childAspectRatio: 1.0),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GalleryGridItem(
                            image: provider.galleryList.data![index],
                            onImageTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.galleryDetail,
                                  arguments: provider.galleryList.data![index]);
                            });
                      },
                      childCount: provider.galleryList.data!.length,
                    ),
                  )
                ]),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
