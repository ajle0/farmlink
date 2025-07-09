

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/viewobject/best_choice.dart';

class BestChoiceSliderView extends StatefulWidget {
  const BestChoiceSliderView({
    super.key,
    required this.bestChoiceList,
    this.onTap,
  });

  final Function? onTap;
  final List<BestChoice> bestChoiceList;

  @override
  _BlogSliderState createState() => _BlogSliderState();
}

class _BlogSliderState extends State<BestChoiceSliderView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final Widget activeDot = Container(
        width: 18.0,
        padding: const EdgeInsets.only(
            left: PsDimens.space2, right: PsDimens.space2),
        child: MaterialButton(
          height: 8.0,
          color: PsColors.mainColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)),
          onPressed: () {},
      ));
    final Widget inactiveDot = Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: PsColors.grey));

    return Stack(
      children: <Widget>[
        if ( widget.bestChoiceList.isNotEmpty)
           CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                height: PsDimens.space160,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(
                    () {
                      _currentIndex = index;
                    },
                  );
                },
              ),
            items: widget.bestChoiceList.map((BestChoice bestChoice) {
              return GestureDetector(
                onTap: () {
                  widget.onTap!(bestChoice);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space8, 
                      right: PsDimens.space8),
                  width: 300,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                               width: 300,
                                height: 130,
                              child: PsNetworkImage(
                                photoKey: '',
                                defaultPhoto: bestChoice.defaultPhoto!,
                                boxfit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 130,
                             // color: PsColors.black.withOpacity(0.6),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(
                      //     left: PsDimens.space8,
                      //     right: PsDimens.space8,
                      //     top: PsDimens.space16,
                      //   ),
                      //   child: Text(
                      //     bestChoice.name,
                      //     textAlign: TextAlign.start,
                      //     style: Theme.of(context).textTheme.subtitle1.copyWith(
                      //         color: PsColors.white, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // Positioned(
                      //   bottom: 40,
                      //   right: 8,
                      //     child: Container(
                      //       width: 100,
                      //       height: 22,
                      //       child: Text(
                      //         Utils.getString(context, 'best_choice__order_now'),
                      //         textAlign: TextAlign.center,
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .button
                      //             .copyWith(fontWeight: FontWeight.bold, color: PsColors.discountColor),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        else
          Container(),
          Positioned(
              top: 70.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  widget.bestChoiceList.isNotEmpty
                    ? widget.bestChoiceList.map((BestChoice bestChoice) {
                        final int index = widget.bestChoiceList.indexOf(bestChoice);
                        return Container(
                          margin: const EdgeInsets.only(top: PsDimens.space48),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (_currentIndex == index) activeDot else inactiveDot,         
                            ],
                          ),
                        );
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
