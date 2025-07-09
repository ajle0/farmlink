import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:provider/provider.dart';

class PsWidgetWithAppBar<T extends ChangeNotifier> extends StatefulWidget {
  const PsWidgetWithAppBar(
      {super.key,
      required this.builder,
      required this.initProvider,
      this.child,
      this.onProviderReady,
      required this.appBarTitle,
      this.actions = const <Widget>[]});

  final Widget Function(BuildContext context, T provider, Widget? child) builder;
  final Function initProvider;
  final Widget? child;
  final Function(T)? onProviderReady;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarState<T> createState() => _PsWidgetWithAppBarState<T>();
}

class _PsWidgetWithAppBarState<T extends ChangeNotifier>
    extends State<PsWidgetWithAppBar<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle (
            statusBarIconBrightness : Utils.getBrightnessForAppBar(context)
          ),
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(widget.appBarTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith()),
          actions: widget.actions,
          flexibleSpace: Container(
            height: 200,
          ),
          elevation: 0,
        ),
        body: ChangeNotifierProvider<T>(
          lazy: false,
          create: (BuildContext context) {
            final T providerObj = widget.initProvider();
            if (widget.onProviderReady != null) {
              widget.onProviderReady!(providerObj);
            }

            return providerObj;
          },
          child: Consumer<T>(
            builder: widget.builder,
            child: widget.child,
          ),
        ));
  }
}
