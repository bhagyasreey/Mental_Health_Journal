import 'package:flutter/material.dart';

class ForwardButton extends StatelessWidget {
  final Function() onTap;
  
 final IconData icon;
  const ForwardButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Icon(icon),
      );
  
  }
}
