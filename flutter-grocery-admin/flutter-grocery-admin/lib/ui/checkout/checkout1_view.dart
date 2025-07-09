import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/delivery_cost/delivery_cost_provider.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/provider/user/user_provider.dart';
import 'package:fluttermultigrocery/repository/delivery_cost_repository.dart';
import 'package:fluttermultigrocery/repository/user_repository.dart';
import 'package:fluttermultigrocery/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultigrocery/ui/common/dialog/success_dialog.dart';
import 'package:fluttermultigrocery/ui/common/ps_button_widget.dart';
import 'package:fluttermultigrocery/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:fluttermultigrocery/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultigrocery/ui/map/current_location_view.dart';
import 'package:fluttermultigrocery/utils/ps_progress_dialog.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/delivery_cost.dart';
import 'package:fluttermultigrocery/viewobject/holder/delivery_cost_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/profile_update_view_holder.dart';
import 'package:fluttermultigrocery/viewobject/shipping_area.dart';
import 'package:fluttermultigrocery/viewobject/user.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../common/weekly_order_list.dart';

class Checkout1View extends StatefulWidget {
  const Checkout1View(this.updateCheckout1ViewState, this.basketList, {super.key});

  final Function updateCheckout1ViewState;
  final List<Basket> basketList;

  @override
  _Checkout1ViewState createState() {
    final _Checkout1ViewState state = _Checkout1ViewState();
    updateCheckout1ViewState(state);
    return state;
  }
}

class _Checkout1ViewState extends State<Checkout1View> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController costPerChargesController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController shippingAreaController = TextEditingController();
  TextEditingController orderTimeTextEditingController =
      TextEditingController();

  List<ScheduleOrder>? scheduleOrder ;
  bool isSwitchOn = false;
  UserRepository? userRepository;
  ShopInfoProvider? shopInfoProvider;
  DeliveryCostProvider? provider;
  DeliveryCostRepository? deliveryCostRepository;
  UserProvider? userProvider;
  PsValueHolder? valueHolder;

  // bool isClickDeliveryButton = true;
  // bool isClickPickUpButton = false;
  String? deliveryPickUpDate;
  String? deliveryPickUpTime;
  bool isWeeklyScheduleOrder = false;

  bool bindDataFirstTime = true;
  bool callDeliveryCost = true;
  LatLng? latlng;

  DateTime now = DateTime.now();

  String? latestDate;

  dynamic weeklyScheduleSetUp(BuildContext context) {
   final List<ScheduleOrder> list =  <ScheduleOrder>[
      ScheduleOrder(weekDay:Utils.getString(context, 'schedule_order_weekday_monday'), isActive: false, selectedTime: null),
      ScheduleOrder(weekDay: Utils.getString(context, 'schedule_order_weekday_tuesday'), isActive: false, selectedTime: null),
      ScheduleOrder(weekDay: Utils.getString(context, 'schedule_order_weekday_wednesday'), isActive: false, selectedTime: null),
      ScheduleOrder(weekDay: Utils.getString(context, 'schedule_order_weekday_thursday'), isActive: false, selectedTime: null),
      ScheduleOrder(weekDay: Utils.getString(context, 'schedule_order_weekday_friday'), isActive: false, selectedTime: null),
      ScheduleOrder(weekDay: Utils.getString(context, 'schedule_order_weekday_saturday'), isActive: false, selectedTime: null),
      ScheduleOrder(weekDay: Utils.getString(context,'schedule_order_weekday_sunday'), isActive: false, selectedTime: null),
    ];
    scheduleOrder = list;
  }

  dynamic updateDeliveryClick() {
    setState(() {});
    if (userProvider!.isClickDeliveryButton) {
      userProvider!.isClickDeliveryButton = false;
      userProvider!.isClickPickUpButton = true;
    } else {
      userProvider!.isClickDeliveryButton = true;
      userProvider!.isClickPickUpButton = false;
    }
  }

  List<String> getSelectedDayAndTime() {
    final List<String> weekDayList = <String>[];
    final List<String> selectedTimeList = <String>[];
    final List<String> scheduleList = <String>[];
    for (ScheduleOrder schedule in scheduleOrder!) {
      if (schedule.isActive!) {
        weekDayList.add(schedule.weekDay!);
        selectedTimeList.add(schedule.selectedTime!);
      }
    }
    final String weekDays = weekDayList.join(',');
    final String selectedTimes = selectedTimeList.join(',');

    scheduleList.addAll(<String>[weekDays, selectedTimes]);
    return scheduleList;
  }

  dynamic updatePickUpClick() {
    setState(() {});
    if (userProvider!.isClickPickUpButton) {
      userProvider!.isClickPickUpButton = false;
      userProvider!.isClickDeliveryButton = true;
    } else {
      userProvider!.isClickPickUpButton = true;
      userProvider!.isClickDeliveryButton = false;
    }
  }

  dynamic updateOrderByData(String filterName) {
    setState(() {
      userProvider!.selectedRadioBtnName = filterName;
      if (filterName == PsConst.ORDER_TIME_WEEKLY_SCHEDULE) {
        isWeeklyScheduleOrder = true;
      } else {
        isWeeklyScheduleOrder = false;
      }
    });
  }

  dynamic updatDateAndTime(DateTime dateTime) {
    setState(() {});
    latestDate = '$dateTime';
    deliveryPickUpDate =
        DateFormat.yMMMEd('en_US').format(DateTime.parse(latestDate!));

    deliveryPickUpTime = DateFormat.Hm('en_US').format(DateTime.parse(latestDate!));

    orderTimeTextEditingController.text =
        '${deliveryPickUpDate!} ${deliveryPickUpTime!}';
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    deliveryCostRepository = Provider.of<DeliveryCostRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    shopInfoProvider = Provider.of<ShopInfoProvider>(context, listen: false);
    provider = Provider.of<DeliveryCostProvider>(context, listen: false);

    if (callDeliveryCost) {
      if (shopInfoProvider!.shopInfo.data != null &&
          shopInfoProvider!.shopInfo.data!.isArea != null &&
          userProvider!.user.data != null) {
        if (shopInfoProvider!.shopInfo.data!.isArea == PsConst.ZERO) {
          deliveryCostCalculate(
            provider!,
            widget.basketList,
            userProvider!.getUserLatLng(valueHolder!).latitude.toString(),
            userProvider!.getUserLatLng(valueHolder!).longitude.toString(),
          );
          callDeliveryCost = false;
        }
      } else {
        return Container();
      }
    }
    weeklyScheduleSetUp(context);

    if (userProvider!.selectedRadioBtnName == PsConst.ORDER_TIME_ASAP) {
      final DateTime dateTime = DateTime.now()
          .add(Duration(minutes: int.parse(valueHolder!.defaultOrderTime ?? '')));
      updatDateAndTime(dateTime);
    }
    return Consumer<DeliveryCostProvider>(builder:
        (BuildContext context, DeliveryCostProvider provider, Widget? child) {
      if ( userProvider!.user.data != null) {
        if (bindDataFirstTime) {
          /// Shipping Data
          userEmailController.text = userProvider!.user.data!.userEmail!;
          userPhoneController.text = userProvider!.user.data!.userPhone!;
          addressController.text = userProvider!.user.data!.address!;
          print(userProvider!.user.data!.userLat);
          userProvider!.selectedRadioBtnName = PsConst.ORDER_TIME_ASAP;
          // if (userProvider.user.data.area != null) {
          shippingAreaController.text = '${userProvider!.user.data!.area!.areaName !} (${userProvider!.user.data!.area!.currencySymbol!}${userProvider!.user.data!.area!.price!})';
          // }
          userProvider!.selectedArea = userProvider!.user.data!.area;
          latlng = userProvider!.getUserLatLng(valueHolder!);
          bindDataFirstTime = false;
        }

        return SingleChildScrollView(
            child: Container(
          color: PsColors.coreBackgroundColor,
          padding: const EdgeInsets.only(
              left: PsDimens.space16, right: PsDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space16,
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space12,
                    top: PsDimens.space16),
                child: Text(
                  Utils.getString(context, 'checkout1__contact_info'),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
              ),
              const SizedBox(
                height: PsDimens.space16,
              ),
              PsTextFieldWidget(
                  titleText: Utils.getString(context, 'edit_profile__email'),
                  textAboutMe: false,
                  hintText: Utils.getString(context, 'edit_profile__email'),
                  textEditingController: userEmailController,
                  isMandatory: true),
              PsTextFieldWidget(
                  titleText: Utils.getString(context, 'edit_profile__phone'),
                  textAboutMe: false,
                  keyboardType: TextInputType.number,
                  hintText: Utils.getString(context, 'edit_profile__phone'),
                  textEditingController: userPhoneController,
                  isMandatory: true),
              RadioWidget(
                userProvider: userProvider!,
                updateOrderByData: updateOrderByData,
                scheduleOrder: scheduleOrder!,
                orderTimeTextEditingController: orderTimeTextEditingController,
                updatDateAndTime: updatDateAndTime,
                isWeeklySchedule: isWeeklyScheduleOrder,
              ),
              _EditAndDeleteButtonWidget(
                  userProvider: userProvider!,
                  shopInfoProvider: shopInfoProvider!,
                  updateDeliveryClick: updateDeliveryClick,
                  updatePickUpClick: updatePickUpClick,
                  isClickDeliveryButton: userProvider!.isClickDeliveryButton,
                  isClickPickUpButton: userProvider!.isClickPickUpButton),
              const SizedBox(height: PsDimens.space8),
              if (userProvider!.isClickDeliveryButton)
                Column(
                  children: <Widget>[
                    CurrentLocationWidget(
                        provider: provider,
                        shopInfoProvider: shopInfoProvider!,
                        userProvider: userProvider!,
                        basketList: widget.basketList,
                        androidFusedLocation: true,
                        textEditingController: addressController,
                        deliveryCostCalculate: deliveryCostCalculate,
                        valueHolder: valueHolder!),
                    Container(
                        width: double.infinity,
                        height: PsDimens.space120,
                        margin: const EdgeInsets.fromLTRB(PsDimens.space8, 0,
                            PsDimens.space8, PsDimens.space16),
                        decoration: BoxDecoration(
                          color: PsColors.backgroundColor,
                          borderRadius: BorderRadius.circular(PsDimens.space4),
                          border: Border.all(color: PsColors.mainDividerColor),
                        ),
                        child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: addressController,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                left: PsDimens.space12,
                                bottom: PsDimens.space8,
                                top: PsDimens.space10,
                              ),
                              border: InputBorder.none,
                              hintText: Utils.getString(
                                  context, 'edit_profile__address'),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: PsColors.textPrimaryLightColor),
                            ))),
                    if (shopInfoProvider!.shopInfo.data!.isArea != null &&
                        shopInfoProvider!.shopInfo.data!.isArea == PsConst.ONE)
                      PsDropdownBaseWithControllerWidget(
                          title: Utils.getString(context, 'checkout1__area'),
                          textEditingController: shippingAreaController,
                          isMandatory: true,
                          onTap: () async {
                            final dynamic result = await Navigator.pushNamed(
                                context, RoutePaths.areaList);

                            if (result != null && result is ShippingArea) {
                              setState(() {
                                shippingAreaController.text = '${result.areaName!} (${result.currencySymbol!} ${result.price!})';
                                userProvider!.selectedArea = result;
                              });
                            }
                          }),
                    if (shopInfoProvider!.shopInfo.data!.isArea == PsConst.ZERO)
                      if (provider.deliveryCost.data != null)
                        _DeliveryCostWidget(
                            provider: provider, basketList: widget.basketList)
                      else
                        _DefaultDeliveryCostWidget(),
                    const SizedBox(height: PsDimens.space24),
                  ],
                )
              else
                Container(),
            ],
          ),
        ));
      } else {
        return Container();
      }
    });
  }

  dynamic deliveryCostCalculate(DeliveryCostProvider provider,
      List<Basket> basketList, String lat, String lng) async {
    if (await Utils.checkInternetConnectivity()) {
      final DeliveryCostParameterHolder deliveryCostParameterHolder =
          DeliveryCostParameterHolder(
              userLat: lat,
              userLng: lng,
              productId: widget.basketList[0].product!.id);

      await PsProgressDialog.showDialog(context);

      final PsResource<DeliveryCost> apiStatus =
          await provider.postDeliveryCost(deliveryCostParameterHolder.
          toMap());

      if (apiStatus.data != null) {
        PsProgressDialog.dismissDialog();
        costPerChargesController.text = apiStatus.data!.costPerCharges!;
        totalCostController.text = apiStatus.data!.totalCost!;
        setState(() {});
      } else {
        PsProgressDialog.dismissDialog();
        costPerChargesController.text = '0';
        totalCostController.text = '0';
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  dynamic checkIsDataChange(UserProvider userProvider) async {
    if (userProvider.user.data!.userEmail == userEmailController.text &&
        userProvider.user.data!.userPhone == userPhoneController.text &&
        userProvider.user.data!.address == addressController.text &&
        userProvider.user.data!.area!.areaName == shippingAreaController.text &&
        userProvider.user.data!.userLat == userProvider.originalUserLat &&
        userProvider.user.data!.userLng == userProvider.originalUserLng) {
      return true;
    } else {
      return false;
    }
  }

  dynamic callUpdateUserProfile(UserProvider userProvider, DeliveryCostProvider provider) async {
    bool isSuccess = false;

    if (userProvider.isClickPickUpButton && userProvider.selectedArea != null) {
      userProvider.selectedArea!.id = '';
      userProvider.selectedArea!.price = '0.0';
      userProvider.selectedArea!.areaName = '';
    }

    if (userProvider.isClickPickUpButton && provider.deliveryCost.data != null) {
      provider.deliveryCost.data!.totalCost = '0.0';
    }

    if (await Utils.checkInternetConnectivity()) {
      final ProfileUpdateParameterHolder profileUpdateParameterHolder =
          ProfileUpdateParameterHolder(
        userId: userProvider.psValueHolder!.loginUserId,
        userName: userProvider.user.data!.userName,
        userEmail: userEmailController.text.trim(),
        userPhone: userPhoneController.text,
        userAddress: addressController.text,
        userAboutMe: userProvider.user.data!.userAboutMe,
        userAreaId: userProvider.selectedArea!.id,
        userLat: userProvider.user.data!.userLat,
        userLng: userProvider.user.data!.userLng,
      );
      await PsProgressDialog.showDialog(context);
      final PsResource<User> apiStatus = await userProvider
          .postProfileUpdate(profileUpdateParameterHolder.toMap());
      if (apiStatus.data != null) {
        PsProgressDialog.dismissDialog();
        isSuccess = true;

        showDialog<dynamic>(
            context: context,
            builder: (BuildContext contet) {
              return SuccessDialog(
                message: Utils.getString(context, 'edit_profile__success'),
              );
            });
      } else {
        PsProgressDialog.dismissDialog();

        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: apiStatus.message,
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }

    return isSuccess;
  }
}

class RadioWidget extends StatefulWidget {
  const RadioWidget({super.key, 
    required this.userProvider,
    required this.updateOrderByData,
    required this.orderTimeTextEditingController,
    required this.updatDateAndTime,
    required this.scheduleOrder,
    required this.isWeeklySchedule,
    // @required this.userId,
  });
  final UserProvider userProvider;
  final Function updateOrderByData;
  final TextEditingController orderTimeTextEditingController;
  final Function updatDateAndTime;
  final List<ScheduleOrder> scheduleOrder;
  final bool isWeeklySchedule;

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              top: PsDimens.space12,
              right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(Utils.getString(context, 'checkout1__order_time'),
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(' *',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: PsColors.mainColor))
                ],
              )
            ],
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
            Widget>[
          Row(
            children: <Widget>[
              Radio<String>(
                value: widget.userProvider.selectedRadioBtnName!,
                groupValue: PsConst.ORDER_TIME_ASAP,
                onChanged: (String? name) {
                  widget.updateOrderByData(PsConst.ORDER_TIME_ASAP);
                  final DateTime dateTime = DateTime.now().add(Duration(
                      minutes: int.parse(psValueHolder.defaultOrderTime!)));
                  widget.updatDateAndTime(dateTime);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: PsColors.mainColor,
              ),
              Expanded(
                child: Text(
                  '${Utils.getString(context, 'checkout1__asap')} (${psValueHolder.defaultOrderTime!}mins)',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Radio<String>(
                value: widget.userProvider.selectedRadioBtnName!,
                groupValue: PsConst.ORDER_TIME_SCHEDULE,
                onChanged: (String? name) async {
                  widget.updateOrderByData(PsConst.ORDER_TIME_SCHEDULE);

                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true, onChanged: (DateTime date) {},
                      onConfirm: (DateTime date) {
                    final DateTime now = DateTime.now();
                    if (DateTime(date.year, date.month, date.day, date.hour,
                                date.minute, date.second)
                            .difference(DateTime(now.year, now.month, now.day,
                                now.hour, now.minute, now.second))
                            .inDays <
                        0) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'chekcout1__past_date_time_error'),
                            );
                          });
                    } else {
                      print('confirm $date');
                      setState(() {});
                      widget.updatDateAndTime(date);
                    }
                  }, locale: LocaleType.en);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: PsColors.mainColor,
              ),
              Expanded(
                child: Text(
                  Utils.getString(context, 'checkout1__schedule'),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Radio<String>(
                value: widget.userProvider.selectedRadioBtnName!,
                groupValue: PsConst.ORDER_TIME_WEEKLY_SCHEDULE,
                onChanged: (String? name) async {
                  widget.updateOrderByData(PsConst.ORDER_TIME_WEEKLY_SCHEDULE);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: PsColors.mainColor,
              ),
              Expanded(
                child: Text(
                  Utils.getString(context, 'checkout1__weekly_schedule'),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: <Widget>[
                  const Icon(FontAwesome5.calendar),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: PsDimens.space8,
                      right: PsDimens.space8),
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.scheduleOrder,
                          arguments: widget.userProvider.user.data,
                        );
                      },
                      child: Text(
                        Utils.getString(context, 'checkout1__view_my_schedule'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ]),
        if (widget.userProvider.selectedRadioBtnName ==
            PsConst.ORDER_TIME_WEEKLY_SCHEDULE)
          WeeklyOrderTimeList(
            scheduleOrder: widget.scheduleOrder,
          )
        else
          Container(
              width: double.infinity,
              height: PsDimens.space44,
              margin: const EdgeInsets.all(PsDimens.space12),
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                borderRadius: BorderRadius.circular(PsDimens.space4),
                border: Border.all(color: PsColors.mainDividerColor),
              ),
              child: TextField(
                  enabled: widget.userProvider.selectedRadioBtnName ==
                      PsConst.ORDER_TIME_SCHEDULE,
                  enableInteractiveSelection:
                      widget.userProvider.selectedRadioBtnName ==
                          PsConst.ORDER_TIME_SCHEDULE,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  controller: widget.orderTimeTextEditingController,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: widget.userProvider.selectedRadioBtnName ==
                              PsConst.ORDER_TIME_ASAP
                          ? PsColors.textPrimaryLightColor
                          : PsColors.textPrimaryColor),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              onChanged: (DateTime date) {},
                              onConfirm: (DateTime date) {
                            final DateTime now = DateTime.now();
                            if (DateTime(date.year, date.month, date.day,
                                        date.hour, date.minute, date.second)
                                    .difference(DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        now.hour,
                                        now.minute,
                                        now.second))
                                    .inDays <
                                0) {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: Utils.getString(context,
                                          'chekcout1__past_date_time_error'),
                                    );
                                  });
                            } else {
                              print('confirm $date');
                              widget.updatDateAndTime(date);
                            }
                          }, locale: LocaleType.en);
                        },
                        child: Icon(
                          FontAwesome5.calendar,
                          size: PsDimens.space20,
                          color: widget.userProvider.selectedRadioBtnName ==
                                  PsConst.ORDER_TIME_ASAP
                              ? PsColors.textPrimaryLightColor
                              : PsColors.mainColor,
                        )),
                    contentPadding: const EdgeInsets.only(
                      top: PsDimens.space8,
                      left: PsDimens.space12,
                      bottom: PsDimens.space8,
                    ),
                    border: InputBorder.none,
                    hintText: '2020-10-2 3:00 PM',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: PsColors.textPrimaryLightColor),
                  ))),
      ],
    );
  }
}

class _DeliveryCostWidget extends StatelessWidget {
  const _DeliveryCostWidget({
    required this.provider,
    required this.basketList,
  });

  final DeliveryCostProvider provider;
  final List<Basket> basketList;

  @override
  Widget build(BuildContext context) {
    String? currencySymbol;

    if (basketList.isNotEmpty) {
      currencySymbol = basketList[0].product!.currencySymbol!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space16,
              left: PsDimens.space16,
              right: PsDimens.space16,
              bottom: PsDimens.space12),
          child: Text(
            Utils.getString(context, 'checkout__order_delivery'),
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (provider.deliveryCost.data!.distance != null &&
            provider.deliveryCost.data!.distance != '')
          _DeliveryTextWidget(
            deliveryInfoText:
                '${provider.deliveryCost.data!.distance} ${provider.deliveryCost.data!.unit}',
            title:
                '${Utils.getString(context, 'checkout__delivery_distance')} :',
          ),
        _DeliveryTextWidget(
          deliveryInfoText:
              '$currencySymbol ${provider.deliveryCost.data!.costPerCharges}',
          title:
              '${Utils.getString(context, 'checkout__delivery_cost_per_km')} :',
        ),
        _DeliveryTextWidget(
          deliveryInfoText:
              '$currencySymbol ${provider.deliveryCost.data!.totalCost}',
          title:
              '${Utils.getString(context, 'checkout__delivery_total_cost')} :',
        )
      ],
    );
  }
}

class _DefaultDeliveryCostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space16,
              left: PsDimens.space16,
              right: PsDimens.space16,
              bottom: PsDimens.space12),
          child: Text(
            Utils.getString(context, 'checkout__order_delivery'),
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        _DeliveryTextWidget(
          deliveryInfoText: '0',
          title: '${Utils.getString(context, 'checkout__delivery_distance')} :',
        ),
        _DeliveryTextWidget(
          deliveryInfoText: '0',
          title:
              '${Utils.getString(context, 'checkout__delivery_cost_per_km')} :',
        ),
        _DeliveryTextWidget(
          deliveryInfoText: '0',
          title:
              '${Utils.getString(context, 'checkout__delivery_total_cost')} :',
        )
      ],
    );
  }
}

class _DeliveryTextWidget extends StatelessWidget {
  const _DeliveryTextWidget({
    this.deliveryInfoText,
    this.title,
  });

  final String? deliveryInfoText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
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
            deliveryInfoText ?? '-',
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

class _EditAndDeleteButtonWidget extends StatefulWidget {
  const _EditAndDeleteButtonWidget(
      {required this.userProvider,
      required this.shopInfoProvider,
      required this.isClickPickUpButton,
      required this.isClickDeliveryButton,
      required this.updateDeliveryClick,
      required this.updatePickUpClick});

  final UserProvider userProvider;
  final ShopInfoProvider shopInfoProvider;
  final bool isClickDeliveryButton;
  final bool isClickPickUpButton;
  final Function updateDeliveryClick;
  final Function updatePickUpClick;
  @override
  __EditAndDeleteButtonWidgetState createState() =>
      __EditAndDeleteButtonWidgetState();
}

class __EditAndDeleteButtonWidgetState
    extends State<_EditAndDeleteButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: PsDimens.space12),
          SizedBox(
            width: double.infinity,
            height: PsDimens.space40,
            child: Container(
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                border: Border.all(color: PsColors.backgroundColor),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(PsDimens.space12),
                    topRight: Radius.circular(PsDimens.space12)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: PsColors.backgroundColor,
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 0, // has the effect of extending the shadow
                    offset: const Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: PSButtonWidget(
                      hasShadow: true,
                      hasShape: false,
                      textColor: widget.isClickDeliveryButton
                          ? PsColors.white
                          : PsColors.black,
                      width: double.infinity,
                      colorData: widget.isClickDeliveryButton
                          ? PsColors.mainColor
                          : PsColors.white,
                      titleText:
                          Utils.getString(context, 'checkout1__delivery'),
                      onPressed: () async {
                        if (widget
                                .shopInfoProvider.shopInfo.data!.pickupEnabled ==
                            '1') {
                          widget.updateDeliveryClick();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  if (widget.shopInfoProvider.shopInfo.data!.pickupEnabled ==
                      '1')
                    Expanded(
                      child: PSButtonWidget(
                        hasShadow: true,
                        hasShape: false,
                        width: double.infinity,
                        textColor: widget.isClickPickUpButton
                            ? PsColors.white
                            : PsColors.black,
                        colorData: widget.isClickPickUpButton
                            ? PsColors.mainColor
                            : PsColors.white,
                        titleText:
                            Utils.getString(context, 'checkout1__pick_up'),
                        onPressed: () async {
                          widget.updatePickUpClick();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleOrder {
  ScheduleOrder({
    @required this.weekDay,
    @required this.isActive,
    @required this.selectedTime,
  });
  final String? weekDay;
  bool? isActive;
  String? selectedTime;
}
