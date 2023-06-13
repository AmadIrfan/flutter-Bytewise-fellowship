import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.labal,
    required this.onTap,
    this.color = Colors.green,
    this.isLoading = false,
    this.textStyle = const TextStyle(
      fontSize: 18,
    ),
  });

  final TextStyle textStyle;
  final String labal;
  final VoidCallback onTap;
  final bool isLoading;
  final Color color;
  @override
  Widget build(BuildContext context) {
    // print(isLoading);
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: color,
        ),
        width: double.infinity,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                labal,
                style: textStyle,
              ),
      ),
    );
  }
}
