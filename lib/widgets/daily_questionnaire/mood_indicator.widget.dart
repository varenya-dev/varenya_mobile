import 'package:flutter/material.dart';

class MoodIndicator extends StatelessWidget {
  final VoidCallback onPress;
  final String emoji;
  final bool activated;

  const MoodIndicator({
    Key? key,
    required this.onPress,
    required this.emoji,
    required this.activated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Text(
        this.emoji,
        style: TextStyle(
          fontSize:
              MediaQuery.of(context).size.width * (activated ? 0.13 : 0.10),
        ),
      ),
    );
  }
}
