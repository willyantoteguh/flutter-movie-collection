import 'package:flutter/material.dart';

class ButtonSelectGenre extends StatelessWidget {
  final bool isSelected;
  final bool isEnabled;
  final double width;
  final double height;
  final String text;
  final Function onTap;

  const ButtonSelectGenre(
    this.text, {super.key, 
    this.isSelected = false,
    this.isEnabled = true,
    this.width = 144,
    this.height = 60,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap();
                },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (!isEnabled)
                  ? const Color(0xFFE4E4E4)
                  : isSelected
                      ? Colors.blue
                      : Colors.transparent,
              border: Border.all(
                  color: (!isEnabled)
                      ? const Color(0xFFE4E4E4)
                      : isSelected
                          ? Colors.transparent
                          : const Color(0xFFE4E4E4))),
          child: Center(
              child: Text(
            text,
          )),
        ));
  }
}
