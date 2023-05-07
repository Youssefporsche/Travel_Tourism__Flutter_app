import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        child: const GroupButton(
          isRadio: true,
          buttons: ["All", "Restaurants", "Museums", "Hotels", "Parks"],
          options: GroupButtonOptions(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              selectedBorderColor: Colors.blueGrey,
              unselectedBorderColor: Colors.blueGrey,
              // elevation: 5,
              mainGroupAlignment: MainGroupAlignment.start,
              groupingType: GroupingType.row,
              spacing: 5),
        ),
      ),
    );
  }
}
