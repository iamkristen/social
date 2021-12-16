import 'package:flutter/material.dart';
import 'package:social/constant/colors.dart';

AppBar header(context,
    {isApptitle = false, String title = "", removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    centerTitle: true,
    elevation: 5,
    title: Text(
      isApptitle ? "Social" : title,
      style: Theme.of(context).textTheme.headline1!.copyWith(
          color: primaryText,
          fontFamily: isApptitle ? "signatra" : "",
          fontSize: isApptitle ? 50 : 22),
    ),
  );
}
