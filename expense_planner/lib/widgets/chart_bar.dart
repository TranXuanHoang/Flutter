import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String dateLabel;
  final double totalAmount;
  final double spendingPercent;

  ChartBar({this.dateLabel, this.totalAmount, this.spendingPercent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Column(
          children: <Widget>[
            Container(
              height: constrains.maxHeight * 0.15,
              child: FittedBox(
                fit: BoxFit.none,
                // alignment: Alignment.centerLeft,
                child: Text(
                  '\$${totalAmount.toStringAsFixed(0)}',
                ),
              ),
            ),
            Container(
              width: 10,
              height: constrains.maxHeight * 0.6,
              margin: EdgeInsets.symmetric(
                // horizontal: 5,
                vertical: constrains.maxHeight * 0.05,
              ),
              decoration: BoxDecoration(
                //color: Colors.grey,
                border: Border.all(
                  color: Color.fromRGBO(220, 220, 220, 1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: <Widget>[
                  // Method 1: Use a container to draw chart
                  // Container(
                  //   height: 60 * spendingPercent,
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  // ),
                  // Method 2: Use a fractionally sized box to draw chart
                  FractionallySizedBox(
                    heightFactor: spendingPercent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: constrains.maxHeight * 0.15,
              child: Text(
                dateLabel,
              ),
            ),
          ],
        );
      },
    );
  }
}
