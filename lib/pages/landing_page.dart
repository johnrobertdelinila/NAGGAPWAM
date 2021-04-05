import 'package:flutter/material.dart';

import 'Landing_components/footer.dart';
import 'Landing_components/header.dart';
import 'Landing_components/qr_code_entry.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget screens({isTablet = false, isMobile= false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Header(),

          Jumbotron(isTablet: isTablet, isMobile: isMobile,),

          Footer(isMobile: isMobile,)
        ],
      );
    }

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,

        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1200) {
              return screens();
            } else if (constraints.maxWidth > 500 && constraints.maxWidth < 1200) {
              return Scrollbar(
                child: SingleChildScrollView(
                  child: screens(isTablet: true),
                ),
              );
            } else {
              return Scrollbar(
                child: SingleChildScrollView(
                  child: screens(isMobile: true),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}