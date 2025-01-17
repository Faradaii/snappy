import 'package:flutter/material.dart';

class BottomAuthText extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback onPressed;

  const BottomAuthText({
    super.key,
    required this.title,
    required this.body,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          InkWell(
            onTap: onPressed,
            child: Text(body, style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }
}
