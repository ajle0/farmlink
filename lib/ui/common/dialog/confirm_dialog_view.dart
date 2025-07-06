import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/utils/utils.dart';

class ConfirmDialogView extends StatefulWidget {
  const ConfirmDialogView(
      {super.key,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onAgreeTap});

  final String? description, leftButtonText, rightButtonText;
  final Function? onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ConfirmDialogView> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    super.key,
    required this.widget,
  });

  final ConfirmDialogView widget;

  @override
  Widget build(BuildContext context) {
    const Widget spacingWidget = SizedBox(
      width: PsDimens.space4,
    );
    const Widget largeSpacingWidget = SizedBox(
      height: PsDimens.space20,
    );
    final Widget headerWidget = Row(
      children: <Widget>[
        spacingWidget,
        Icon(
          Icons.help_outline,
          color: PsColors.white,
        ),
        spacingWidget,
        Text(
          Utils.getString(context, 'logout_dialog__confirm'),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: PsColors.white,
          ),
        ),
      ],
    );

    final Widget messageWidget = Text(
      widget.description!,
      style: Theme.of(context).textTheme.titleMedium,
    );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: PsDimens.space60,
              width: double.infinity,
              padding: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: PsColors.mainColor),
              child: headerWidget),
          largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space8,
                bottom: PsDimens.space8),
            child: messageWidget,
          ),
          largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(widget.leftButtonText!,
                  style: Theme.of(context).textTheme.labelLarge),
            )),
            Container(
                height: 50,
                width: 0.4,
                color: Theme.of(context).iconTheme.color),
            Expanded(
                child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                widget.onAgreeTap!();
              },
              child: Text(
                widget.rightButtonText!,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: PsColors.mainColor),
              ),
            )),
          ])
        ],
      ),
    );
  }
}
