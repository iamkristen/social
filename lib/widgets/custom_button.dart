import 'package:flutter/material.dart';
import 'package:social/constant/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      margin: const EdgeInsets.all(10.0),
      height: 40,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(letterSpacing: 1.3, color: primaryText, fontSize: 18),
        ),
      ),
    );
  }
}
