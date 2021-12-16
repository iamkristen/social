import 'package:flutter/material.dart';
import 'package:social/constant/colors.dart';

Container circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10.0),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(primaryColor),
      ));
}

linearProgress() {
  return const LinearProgressIndicator(
    backgroundColor: primaryText,
    valueColor: AlwaysStoppedAnimation(primaryColor),
  );
}
