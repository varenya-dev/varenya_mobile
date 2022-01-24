import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class MainFilter extends StatelessWidget {
  final Function buildJobFilter;
  final Function buildSpecializationFilter;

  const MainFilter({
    Key? key,
    required this.buildJobFilter,
    required this.buildSpecializationFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    "Filter Options",
                  ),
                ),
                collapsed: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    "Tap To Show Filter Options",
                  ),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    this.buildJobFilter(),
                    this.buildSpecializationFilter(),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(
                      crossFadePoint: 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
