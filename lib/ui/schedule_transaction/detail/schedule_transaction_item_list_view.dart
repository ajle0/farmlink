import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/provider/schedule/schedule_detail_provider.dart';
import 'package:fluttermultigrocery/provider/schedule/schedule_header_provider.dart';
import 'package:fluttermultigrocery/repository/schedule_detail_repository.dart';
import 'package:fluttermultigrocery/repository/schedule_header_repository.dart';
import 'package:fluttermultigrocery/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultigrocery/ui/common/ps_button_widget.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/schedule_transaction/detail/schedule_transaction_item_view.dart';
import 'package:fluttermultigrocery/utils/ps_progress_dialog.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/schedule_header.dart';
import 'package:provider/provider.dart';

class ScheduleTransactionItemListView extends StatefulWidget {
  const ScheduleTransactionItemListView({
    super.key,
    required this.scheduleHeader,
  });

  final ScheduleHeader scheduleHeader;

  @override
  _ScheduleTransactionItemListViewState createState() =>
      _ScheduleTransactionItemListViewState();
}

class _ScheduleTransactionItemListViewState
    extends State<ScheduleTransactionItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ScheduleDetailRepository? repo1;
  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? valueHolder;
  ScheduleDetailProvider? _scheduleDetailProvider;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scheduleDetailProvider!
            .loadnextScheduleDetailList(widget.scheduleHeader);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
    Future<bool> requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    repo1 = Provider.of<ScheduleDetailRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    return WillPopScope(
        onWillPop: requestPop,
        child: ChangeNotifierProvider<ScheduleDetailProvider>(
          lazy: false,
          create: (BuildContext context) {
            final ScheduleDetailProvider provider =
                ScheduleDetailProvider(repo: repo1, valueHolder: valueHolder);
            provider.loadScheduleDetailList(widget.scheduleHeader);

            _scheduleDetailProvider = provider;
            return provider;
          },
          child: Consumer<ScheduleDetailProvider>(builder:
              (BuildContext context, ScheduleDetailProvider provider,
                  Widget? child) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness:
                        Utils.getBrightnessForAppBar(context)),
                iconTheme: Theme.of(context).iconTheme.copyWith(),
                title: Text(
                  Utils.getString(context, 'transaction_detail__title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                elevation: 0,
              ),
              body: Stack(children: <Widget>[
                RefreshIndicator(
                  child: CustomScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: _OrderStatusWidget(
                              scheduleHeader: widget.scheduleHeader,
                              valueHolder: valueHolder!,
                              scaffoldKey: scaffoldKey),
                        ),
                        SliverToBoxAdapter(
                          child: _ScheduleHeaderNoWidget(
                              scheduleHeader: widget.scheduleHeader,
                              valueHolder: valueHolder!,
                              scaffoldKey: scaffoldKey),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.scheduleDetailList.data != null ||
                                  provider.scheduleDetailList.data!.isNotEmpty) {
                                final int count =
                                    provider.scheduleDetailList.data!.length;
                                print('Count Length : $count');
                                return ScheduleTransactionItemView(
                                  animationController: animationController!,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  scheduleDetail:
                                      provider.scheduleDetailList.data![index],
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount: provider.scheduleDetailList.data!.length,
                          ),
                        ),
                      ]),
                  onRefresh: () {
                    return provider
                        .resetScheduleDetailList(widget.scheduleHeader);
                  },
                ),
                PSProgressIndicator(provider.scheduleDetailList.status)
              ]),
            );
          }),
        ));
  }
}

class _OrderStatusWidget extends StatelessWidget {
  const _OrderStatusWidget({
    required this.scheduleHeader,
    required this.valueHolder,
    this.scaffoldKey,
  });

  final ScheduleHeader scheduleHeader;
  final PsValueHolder valueHolder;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    const Widget dividerWidget = Divider(
      height: PsDimens.space2,
    );
    final Widget contentCopyIconWidget = IconButton(
      iconSize: PsDimens.space20,
      icon: Icon(
        Icons.content_copy,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: scheduleHeader.transCode ?? ''));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    );

    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    Icon(
                      Icons.offline_pin,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    Expanded(
                      child: Text(
                          '${Utils.getString(context, 'transaction_detail__trans_no')} : ${scheduleHeader.transCode}',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ],
                ),
              ),
              contentCopyIconWidget,
            ],
          ),
        ),
        dividerWidget,
        if (scheduleHeader.pickAtShop == PsConst.ZERO)
          Column(
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space12,
              ),
              // if (scheduleHeader.refundStatus != '2')
              //   _ScheduleHeaderStatusListWidget(scheduleHeader: scheduleHeader)
              // else
              _RefundedStatusWidget(
                scheduleHeader: scheduleHeader,
              ),
              const SizedBox(
                height: PsDimens.space6,
              ),
            ],
          )
        else
          Container()
      ],
    ));
  }
}

class _ScheduleHeaderNoWidget extends StatelessWidget {
  const _ScheduleHeaderNoWidget({
    required this.scheduleHeader,
    required this.valueHolder,
    this.scaffoldKey,
  });

  final ScheduleHeader scheduleHeader;
  final PsValueHolder valueHolder;
  final GlobalKey<ScaffoldState> ?scaffoldKey;

  @override
  Widget build(BuildContext context) {
    const Widget dividerWidget = Divider(
      height: PsDimens.space2,
    );

    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space8,
                  right: PsDimens.space12,
                  top: PsDimens.space12,
                  bottom: PsDimens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Icon(
                          Octicons.note,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Expanded(
                          child: Text(
                              Utils.getString(
                                  context, 'checkout__order_summary'),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            dividerWidget,
            if (scheduleHeader.pickAtShop == PsConst.ONE)
              _ScheduleHeaderNoTextWidget(
                transationInfoText:
                    '${scheduleHeader.deliveryPickupDate} ${scheduleHeader.deliveryPickupTime}',
                title:
                    '${Utils.getString(context, 'transaction_detail__order_time')} :',
              )
            else
              Container(),
            _ScheduleHeaderNoTextWidget(
              transationInfoText: scheduleHeader.totalItemCount!,
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_count')} :',
            ),
            _ScheduleHeaderNoTextWidget(
              transationInfoText:
                  '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.totalItemAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_price')} :',
            ),
            _ScheduleHeaderNoTextWidget(
              transationInfoText: scheduleHeader.discountAmount == '0'
                  ? '-'
                  : '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.discountAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__discount')} :',
            ),
            _ScheduleHeaderNoTextWidget(
              transationInfoText: scheduleHeader.cuponDiscountAmount == '0'
                  ? '-'
                  : '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.cuponDiscountAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__coupon_discount')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            dividerWidget,
            _ScheduleHeaderNoTextWidget(
              transationInfoText:
                  '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.subTotalAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            ),
            _ScheduleHeaderNoTextWidget(
              transationInfoText:
                  '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.taxAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__tax')}(${scheduleHeader.taxPercent} %) :',
            ),
            _ScheduleHeaderNoTextWidget(
              transationInfoText:
                  '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.shippingAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_cost')} :',
            ),
            _ScheduleHeaderNoTextWidget(
              transationInfoText:
                  '${scheduleHeader.currencySymbol} ${Utils.calculateShippingTax(scheduleHeader.shippingAmount, scheduleHeader.shippingTaxPercent, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_tax')}(${scheduleHeader.shippingTaxPercent} %) :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            dividerWidget,
            _ScheduleHeaderNoTextWidget(
              transationInfoText:
                  '${scheduleHeader.currencySymbol} ${Utils.getPriceFormat(scheduleHeader.balanceAmount!, valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
          ],
        ));
  }
}

class _ScheduleHeaderNoTextWidget extends StatelessWidget {
  const _ScheduleHeaderNoTextWidget({
    required this.transationInfoText,
    this.title,
  });

  final String transationInfoText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          top: PsDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}

class _RefundedStatusWidget extends StatelessWidget {
  const _RefundedStatusWidget({
    required this.scheduleHeader,
  });

  final ScheduleHeader scheduleHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PsDimens.space220,
      height: PsDimens.space40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PsColors.mainLightColor,
        borderRadius: BorderRadius.circular(PsDimens.space12),
        border: Border.all(color: PsColors.mainLightColor),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(Utils.getString(context, 'refund_status_refunded'),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: PsColors.mainColor)),
      ),
    );
  }
}

class _RefundButtonWidget extends StatefulWidget {
  const _RefundButtonWidget({
    required this.scheduleHeader,
  });

  final ScheduleHeader scheduleHeader;

  @override
  __RefundButtonWidgetState createState() => __RefundButtonWidgetState();
}

class __RefundButtonWidgetState extends State<_RefundButtonWidget> {
  PsValueHolder? valueHolder;
  ScheduleHeaderRepository? scheduleHeaderHeaderRepo;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    scheduleHeaderHeaderRepo = Provider.of<ScheduleHeaderRepository>(context);
    // final ScheduleDetailProvider scheduleHeaderDetailProvider =
    //     Provider.of<ScheduleDetailProvider>(context, listen: false);

    return ChangeNotifierProvider<ScheduleHeaderProvider>(
      lazy: false,
      create: (BuildContext context) {
        final ScheduleHeaderProvider scheduleHeaderHeaderProvider =
            ScheduleHeaderProvider(
                repo: scheduleHeaderHeaderRepo, psValueHolder: valueHolder);
        return scheduleHeaderHeaderProvider;
      },
      child: Consumer<ScheduleHeaderProvider>(builder: (BuildContext context,
          ScheduleHeaderProvider provider, Widget? child) {
        provider = ScheduleHeaderProvider(
            repo: scheduleHeaderHeaderRepo, psValueHolder: valueHolder);
        return Container(
          padding: const EdgeInsets.only(
              left: PsDimens.space18,
              right: PsDimens.space12,
              bottom: PsDimens.space24),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'refund_button_refund'),
            onPressed: () async {
              if (widget.scheduleHeader.id != '') {
                if (await Utils.checkInternetConnectivity()) {
                  await PsProgressDialog.showDialog(context);

                  // await provider.postRefund(widget.scheduleHeaderHeader.id);

                  PsProgressDialog.dismissDialog();
                  print('Fail');
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(context, 'refund__fail'),
                        );
                      });
                                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              }
            },
          ),
        );
      }),
    );
  }
}
