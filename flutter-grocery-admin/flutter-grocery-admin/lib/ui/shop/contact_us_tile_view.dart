import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_expansion_tile.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/shop_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsTileView extends StatelessWidget {
  const ContactUsTileView({
    super.key,
    required this.shopInfo,
  });

  final ShopInfo shopInfo;
  @override
  Widget build(BuildContext context) {
    final Widget expansionTileTitleWidget = Text(
        Utils.getString(context, 'shop_info__contact'),
        style: Theme.of(context).textTheme.titleLarge);
    if ( shopInfo.description != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: PsDimens.space16,
                  left: PsDimens.space16,
                  right: PsDimens.space16),
              child: Column(
                children: <Widget>[
                  _PhoneAndContactWidget(
                    phone: shopInfo,
                  ),
                  _LinkAndTitle(
                      icon: FontAwesome.wordpress,
                      title: Utils.getString(
                          context, 'shop_info__visit_our_website'),
                      link: shopInfo.aboutWebsite!),
                  _LinkAndTitle(
                      icon: FontAwesome.facebook,
                      title: Utils.getString(context, 'shop_info__facebook'),
                      link: shopInfo.facebook!),
                  _LinkAndTitle(
                      icon: FontAwesome.google_plus_circle,
                      title: Utils.getString(context, 'shop_info__google_plus'),
                      link: shopInfo.googlePlus!),
                  _LinkAndTitle(
                      icon: FontAwesome.twitter_squared,
                      title: Utils.getString(context, 'shop_info__twitter'),
                      link: shopInfo.twitter!),
                  _LinkAndTitle(
                      icon: FontAwesome.instagram,
                      title: Utils.getString(context, 'shop_info__instagram'),
                      link: shopInfo.instagram!),
                  _LinkAndTitle(
                      icon: FontAwesome.youtube,
                      title: Utils.getString(context, 'shop_info__youtube'),
                      link: shopInfo.youtube!),
                  _LinkAndTitle(
                      icon: FontAwesome.pinterest,
                      title: Utils.getString(context, 'shop_info__pinterest'),
                      link: shopInfo.pinterest!),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _PhoneAndContactWidget extends StatelessWidget {
  const _PhoneAndContactWidget({
    required this.phone,
  });

  final ShopInfo phone;
  @override
  Widget build(BuildContext context) {
    const Widget spacingWidget = SizedBox(
      height: PsDimens.space16,
    );
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space16),
        padding: const EdgeInsets.only(
            left: PsDimens.space16, right: PsDimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            spacingWidget,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: PsDimens.space20,
                    height: PsDimens.space20,
                    child: const Icon(
                      Icons.phone_in_talk,
                    )),
                const SizedBox(
                  width: PsDimens.space12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'shop_info__phone'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    spacingWidget,
                    InkWell(
                      child: Text(
                        phone.aboutPhone1 == '' ? '-' : phone.aboutPhone1!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                      ),
                      onTap: () async {
                        if (await canLaunchUrl(Uri.parse('tel://${phone.aboutPhone1}'))) {
                          await launchUrl(Uri.parse('tel://${phone.aboutPhone1}'));
                        } else {
                          throw 'Could not Call Phone Number 1';
                        }
                      },
                    ),
                    spacingWidget,
                    InkWell(
                      child: Text(
                        phone.aboutPhone2 == '' ? '-' : phone.aboutPhone2!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                      ),
                      onTap: () async {
                        if (await canLaunchUrl(Uri.parse('tel://${phone.aboutPhone2}'))) {
                          await launchUrl(Uri.parse('tel://${phone.aboutPhone2}'));
                        } else {
                          throw 'Could not Call Phone Number 2';
                        }
                      },
                    ),
                    spacingWidget,
                    InkWell(
                      child: Text(
                        phone.aboutPhone3 == '' ? '-' : phone.aboutPhone3!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                      ),
                      onTap: () async {
                        if (await canLaunchUrl(Uri.parse('tel://${phone.aboutPhone3}'))) {
                          await launchUrl(Uri.parse('tel://${phone.aboutPhone3}'));
                        } else {
                          throw 'Could not Call Phone Number 3';
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            spacingWidget,
          ],
        ));
  }
}

class _LinkAndTitle extends StatelessWidget {
  const _LinkAndTitle({
    required this.icon,
    required this.title,
    required this.link,
  });

  final IconData icon;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  SizedBox(
                      width: PsDimens.space20,
                      height: PsDimens.space20,
                      child: Icon(
                        icon,
                      )),
                  const SizedBox(
                    width: PsDimens.space12,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space32,
                  ),
                  InkWell(
                    child: Text(
                        link == ''
                            ? Utils.getString(context, 'shop_info__dash')
                            : link,
                        style: Theme.of(context).textTheme.bodyLarge),
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(link))) {
                        await launchUrl(Uri.parse(link));
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
