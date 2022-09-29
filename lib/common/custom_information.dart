import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomInformation extends StatelessWidget {
  final String imgPath;
  final String title;
  final String subtitle;
  final Widget? child;

  const CustomInformation({
    Key? key,
    required this.imgPath,
    required this.title,
    required this.subtitle,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: SvgPicture.asset(
              imgPath,
              width: 150,
              fit: BoxFit.fill,
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
          Flexible(
            child: Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          if (child != null) ...[child!]
        ],
      ),
    );
  }
}
