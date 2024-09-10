import 'package:start_page/pages/settings/forward_button.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;

  final IconData icon;
  final Function() onTap;
  final String? value;
  const SettingItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: bgColor,
            ),
          ),
          // const SizedBox(width: 20),
          ForwardButton(
            onTap: onTap,
            icon: icon,
          ),
        ],
      ),
    );
  }
}
