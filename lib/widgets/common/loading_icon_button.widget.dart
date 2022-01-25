import 'package:flutter/material.dart';

class LoadingIconButton extends StatelessWidget {
  final bool connected;
  final bool loading;
  final VoidCallback onFormSubmit;

  final String text;
  final String loadingText;

  const LoadingIconButton({
    Key? key,
    required this.connected,
    required this.loading,
    required this.onFormSubmit,
    required this.text,
    required this.loadingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          this.loading
              ? Colors.grey[900]!
              : connected
                  ? Colors.yellow
                  : Colors.grey[900],
        ),
      ),
      onPressed: connected
          ? !this.loading
              ? this.onFormSubmit
              : null
          : null,
      label: Text(
        connected
            ? !this.loading
                ? this.text
                : this.loadingText
            : 'You are offline',
      ),
      icon: connected
          ? !this.loading
              ? Icon(
                  Icons.edit,
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.longestSide * 0.025,
                  width: MediaQuery.of(context).size.longestSide * 0.025,
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
          : Icon(
              Icons.offline_bolt_outlined,
            ),
    );
  }
}
