
import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/ps_app_version.dart';
import 'package:provider/provider.dart';

class ForceUpdateView extends StatelessWidget {
  ForceUpdateView({super.key, required this.psAppVersion});
  final PSAppVersion psAppVersion;
  final Widget _imageWidget = SizedBox(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/flutter_grocery_logo.png',
    ),
  );
  @override
  Widget build(BuildContext context) {
    Provider.of<PsValueHolder>(context);
    return Container(
        height: 100,
        color: PsColors.mainLightColor,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space80,
                    ),
                    _imageWidget,
                    const SizedBox(
                      height: PsDimens.space16,
                    ),
                    Text(Utils.getString(context, 'app_name'),
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space16, right: PsDimens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space32,
                    ),
                    Text(psAppVersion.versionTitle!,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    SizedBox(
                        height: PsDimens.space100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            psAppVersion.versionMessage!,
                            maxLines: 9,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space32, right: PsDimens.space32),
                      child: MaterialButton(
                        color: PsColors.mainColor,
                        height: 45,
                        minWidth: double.infinity,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: Text(
                          Utils.getString(context, 'force_update__update'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: PsColors.white),
                        ),
                        onPressed: () async {
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
