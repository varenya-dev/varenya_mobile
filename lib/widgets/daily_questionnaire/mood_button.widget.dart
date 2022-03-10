import 'package:flutter/material.dart';
import 'package:varenya_mobile/utils/palette.util.dart';

class MoodButton extends StatelessWidget {
  final VoidCallback onPress;
  final String emojiPath;
  final bool selected;

  const MoodButton({
    Key? key,
    required this.emojiPath,
    required this.onPress,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.03,
        ),
        margin: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
          color:
              selected ? Palette.primary.withOpacity(0.6) : Palette.secondary,
          border: Border.all(
            color: selected ? Palette.primary : Colors.grey[850]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        child: Image.asset(
          this.emojiPath,
        ),
      ),
    );
  }
}
