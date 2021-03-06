import 'package:flutter/material.dart';
import 'package:varenya_mobile/utils/palette.util.dart';

class AppointmentButton extends StatelessWidget {
  final VoidCallback onConfirm;
  final bool loading;

  AppointmentButton({
    Key? key,
    required this.onConfirm,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.01,
          ),
          decoration: BoxDecoration(
            color: Palette.secondary,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: this.onConfirm,
                child: !loading
                    ? Container(
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: Text(
                          'Confirm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).size.longestSide * 0.025,
                          width:
                              MediaQuery.of(context).size.longestSide * 0.025,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Palette.secondary,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
