import 'package:covidcapstone/Services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class Footer extends StatelessWidget {

  final isMobile;

  const Footer({Key key, this.isMobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> contents() {
      return [
        Expanded(
            flex: 1,
            child: Text(
              'Copyright © 2021 | NAGGAPWAM WEB',
              style: TextStyle(
                  fontSize: 10
              ),
            )
        ),
        Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                NavItem(
                  title: 'CONTACT US',
                  tapEvent: () {},
                ),
                NavItem(
                  title: 'FACEBOOK PAGE',
                  tapEvent: () {},
                ),
                NavItem(
                  title: 'NAGGAPWAM HOTLINE',
                  tapEvent: () {},
                ),
                NavItem(
                  title: 'FEEDBACK',
                  tapEvent: () {},
                ),
              ],
            )
        )
      ];
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: isMobile ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavItem(
            title: 'CONTACT US',
            tapEvent: () {},
          ),
          NavItem(
            title: 'FACEBOOK PAGE',
            tapEvent: () {},
          ),
          NavItem(
            title: 'NAGGAPWAM HOTLINE',
            tapEvent: () {},
          ),
          NavItem(
            title: 'FEEDBACK',
            tapEvent: () {},
          ),
          SizedBox(height: 5,),
          Text(
            'Copyright © 2021 | NAGGAPWAM ' + (kIsWeb ? "WEB" : "MOBILE"),
            style: TextStyle(
                fontSize: 14
            ),
          ),
        ]
      ) : Row(children: contents()),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    Key key,
    @required this.title,
    @required this.tapEvent
  }) : super(key: key);

  final String title;
  final GestureTapCallback tapEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapEvent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: (kIsWeb ? 15 : 0)),
        child: Text(
          title,
          style: TextStyle(
            color: mainColor,
            fontSize: (kIsWeb ? 12 : 15)
          ),
        ),
      ),
    );
  }
}