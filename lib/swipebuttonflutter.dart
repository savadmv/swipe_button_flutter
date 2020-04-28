library swipebuttonflutter;

/// Swipe button
import 'package:flutter/material.dart';
import 'package:swipebuttonflutter/swipable_button.dart';

/// Button that swipe and increase its width to maximum
class SwipingButton extends StatefulWidget {
  /// The text that the button will display.
  final String text;
  /// with of the button
  final double width;

  /// The callback invoked when the button is swiped.
  final VoidCallback onSwipeCallback;

  /// Optional changes
  final Color swipeButtonColor;
  final Color backgroundColor;
  final Color iconColor;
  TextStyle buttonTextStyle;

  SwipingButton({
    Key key,
    @required this.text,
    this.width = 80,
    @required this.onSwipeCallback,
    this.swipeButtonColor = Colors.amber,
    this.backgroundColor = Colors.black,
    this.iconColor = Colors.white,
    this.buttonTextStyle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateSwipingButton(
      text: text,
      onSwipeCallback: onSwipeCallback,
      width: width,
      swipeButtonColor: this.swipeButtonColor,
      backgroundColor: this.backgroundColor,
      iconColor: this.iconColor,
      buttonTextStyle: this.buttonTextStyle);
}

class StateSwipingButton extends State<SwipingButton> {
  /// The text that the button will display.
  final String text;
  final double width;

  /// The callback invoked when the button is swiped.
  final VoidCallback onSwipeCallback;
  bool isSwiping = false;
  double opacityVal = 1;
  final Color swipeButtonColor;
  final Color backgroundColor;
  final Color iconColor;
  TextStyle buttonTextStyle;

  StateSwipingButton({
    Key key,
    @required this.text,
    @required this.width,
    @required this.onSwipeCallback,
    this.swipeButtonColor = Colors.amber,
    this.backgroundColor = Colors.black,
    this.iconColor = Colors.white,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonTextStyle == null) {
      buttonTextStyle = TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w800, color: Colors.white);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Stack(
        children: <Widget>[
          Container(
            height: width,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(width / 2)),
            child: new Center(
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SwipeableWidget(
            height: width,
            screenSize: MediaQuery.of(context).size.width,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildContent(),
              ),
              height: width,
              decoration: BoxDecoration(
                  color: swipeButtonColor,
                  borderRadius: BorderRadius.circular(width / 2)),
            ),
            onSwipeCallback: onSwipeCallback,
            onSwipeStartcallback: (val, conVal) {
              print("isGrate $conVal");
              setState(() {
                isSwiping = val;
                opacityVal = 1 - conVal;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Flexible(
      flex: 5,
      child: Text(
        text.toUpperCase(),
        style: buttonTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: AnimatedOpacity(
                opacity:
                    (opacityVal - 0.2).isNegative ? 0.0 : (opacityVal - 0.2),
                duration: Duration(milliseconds: 10),
                child: Icon(
                  Icons.chevron_right,
                  color: iconColor,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: AnimatedOpacity(
                opacity:
                    (opacityVal - 0.2).isNegative ? 0.0 : (opacityVal - 0.2),
                duration: Duration(milliseconds: 10),
                child: Icon(
                  Icons.chevron_right,
                  color: iconColor,
                ),
              ),
            ),
            isSwiping
                ? _buildText()
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ],
    );
  }
}
