import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String title;
  final String iconAsset;
  final VoidCallback? onPressed;

  const SocialSignInButton({
    Key? key,
    required this.title,
    required this.iconAsset,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the provided iconAsset path
            Image.asset(
              iconAsset,
              width: 24, // Set size for the Google icon
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
