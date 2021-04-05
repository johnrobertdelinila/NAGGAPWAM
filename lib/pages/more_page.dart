
import 'package:covidcapstone/Widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';

import 'landing_components/footer.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollviewAdaptive(
      icon: GestureDetector(child: notifOut, onTap: () => Navigator.of(context).pushNamed("/notification"),),
      widgets: [
        Footer(isMobile: true,)
      ],
      title: navigations[2]
    );
  }

}