import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/provider/user/user_provider.dart';
import 'package:fluttermultigrocery/repository/user_repository.dart';
import 'package:fluttermultigrocery/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappCheckoutView extends StatefulWidget {
  const WhatsappCheckoutView({
    super.key,
    required this.basketList,
  });

  final List<Basket> basketList;

  @override
  _WhatsappCheckoutViewState createState() {
    final _WhatsappCheckoutViewState state = _WhatsappCheckoutViewState();
    return state;
  }
}

class _WhatsappCheckoutViewState extends State<WhatsappCheckoutView> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  UserRepository? userRepository;
  UserProvider? userProvider;
  PsValueHolder? valueHolder;
  bool bindDataFirstTime = true;
  
  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    
    double totalPrice = 0.0;
    String? currencySymbol;

    if (widget.basketList.isNotEmpty) {
      totalPrice += double.parse(widget.basketList[0].basketPrice!) * double.parse(widget.basketList[0].qty!);

      currencySymbol = widget.basketList[0].product!.currencySymbol!;
    }
     return ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          userProvider =
              UserProvider(repo: userRepository!, psValueHolder: valueHolder);
          userProvider!.getUser(userProvider!.psValueHolder!.loginUserId!);
          return userProvider!;
      },
      child: Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget? child) {
    
        if ( userProvider.user.data != null) {
          if (bindDataFirstTime) {
            userNameController.text = userProvider.user.data!.userName!;
            userEmailController.text = userProvider.user.data!.userEmail!;
            userPhoneController.text = userProvider.user.data!.userPhone!;
            userAddressController.text = userProvider.user.data!.address!;
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
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'whatsapp__title_name'),
                        textAboutMe: false,
                        hintText: Utils.getString(context, 'whatsapp__name'),
                        textEditingController: userNameController,
                        ),
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'whatsapp__title_phone_no'),
                        textAboutMe: false,
                        hintText: Utils.getString(context, 'whatsapp__phone_no'),
                        textEditingController: userPhoneController,
                        ),
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'whatsapp__title_email'),
                        textAboutMe: false,
                        hintText: Utils.getString(context, 'whatsapp__email'),
                        textEditingController: userEmailController,
                        ),
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'whatsapp__title_address'),
                        height: PsDimens.space72,
                        textAboutMe: true,
                        hintText: Utils.getString(context, 'whatsapp__address'),
                        keyboardType: TextInputType.multiline,
                        textEditingController: userAddressController),
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'checkout3__memo'),
                        height: PsDimens.space72,
                        textAboutMe: true,
                        hintText: Utils.getString(context, 'checkout3__memo'),
                        keyboardType: TextInputType.multiline,
                        textEditingController: memoController),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: PsDimens.space8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                Utils.getString(context, 'whatsapp__view_order'),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                '${Utils.getString(context, 'checkout__total')} ${Utils.getPriceFormat(totalPrice.toString(), valueHolder!)} $currencySymbol',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                      const SizedBox(height: PsDimens.space12),
                      Card(
                        elevation: 0,
                        color: PsColors.mainColor,
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(PsDimens.space8))),
                        child: InkWell(
                          onTap: () async {
                            final String whatsAppOrder = 'Name: ${userNameController.text}\nPhone Number: ${userPhoneController.text}\nEmail: ${userEmailController.text}\nAddress: ${userAddressController.text}\nMemo: ${memoController.text}';
                            await launchUrl(Uri.parse(
                                'https://wa.me/${widget.basketList[0].product!.shop!.whapsappNo}?text=$whatsAppOrder'));
                              
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space4, right: PsDimens.space4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[
                                  PsColors.mainColor,
                                  PsColors.mainDarkColor,
                                ]),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(PsDimens.space12)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: PsColors.mainColorWithBlack.withOpacity(0.6),
                                      offset: const Offset(0, 4),
                                      blurRadius: 8.0,
                                      spreadRadius: 3.0),
                                ],
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Utils.getString(
                                          context, 'whatsapp__checkout_button_name'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: PsColors.white),
                                    ),
                                  ],
                                )
                              ),
                          ),
                        ),
                        const SizedBox(height: PsDimens.space8),
                      ],
                    ),
                  ]),
                )
              );
            } else {
              return Container();
            }
        }),
      );
    }
}