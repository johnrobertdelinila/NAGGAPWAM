

import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/scrollbar_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class CustomScrollviewAdaptive
    extends StatelessWidget {

  final List<Widget> widgets;
  final String title;
  final Widget icon;

  const CustomScrollviewAdaptive({Key key, @required this.widgets, @required this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle mobileTextStyle = TextStyle(color: Colors.black);
    TextStyle webTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700);

    var text = Padding(
      padding: EdgeInsets.only(top: (kIsWeb ? 8 : 0)),
      child: Row(
        children: [
          (kIsWeb ? Image.asset(
            'assets/images/logo.png',
            width: 35,
          ) : SizedBox()),
          Text(title, style: (kIsWeb ? webTextStyle : mobileTextStyle),)
        ],
      ),
    );

    // var text = Text(title, style: (kIsWeb ? webTextStyle : mobileTextStyle),);

    return ScrollbarAdaptive(
      child: CustomScrollView(
        slivers: [
          if (isIos) CupertinoSliverNavigationBar(
            heroTag: "title",
            largeTitle: text,
            backgroundColor: backgroundColor,
            trailing: icon,
            transitionBetweenRoutes: true,
            border: null
          ) else SliverAppBar(
            leading: (navigations.contains(title) || kIsWeb ? null : IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.black,))),
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: kIsWeb ? navColor : backgroundColor,
            actions: [
              Padding(padding: EdgeInsets.only(right: 10),
              child: icon)
            ],
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              title: text,
              centerTitle: false,
              titlePadding: (navigations.contains(title) ? EdgeInsets.only(left: 15, bottom: 15) : null),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(widgets)
          ),
        ],
      ),
    );
  }
}