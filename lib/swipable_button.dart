import 'package:flutter/material.dart';

/// A Widget that have the ability to detect swipe on itself
/// with customizable variables.
class SwipeableWidget extends StatefulWidget {
  /// The `Widget` on which we want to detect the swipe movement.
  final Widget child;

  /// The Height of the widget that will be drawn, required.
  final double height;

  /// The `VoidCallback` that will be called once a swipe with certain percentage is detected.
  final VoidCallback onSwipeCallback;

  /// The decimal percentage of swiping in order for the callbacks to get called, defaults to 0.75 (75%) of the total width of the children.
  final double? swipePercentageNeeded;

  final double screenSize;

  final Function(bool, double) onSwipeStartcallback;

  SwipeableWidget(
      {Key? key,
      required this.child,
      required this.height,
      required this.onSwipeCallback,
      required this.onSwipeStartcallback,
      required this.screenSize,
      this.swipePercentageNeeded = 0.75})
      : assert(child != null &&
            onSwipeCallback != null &&
            swipePercentageNeeded! <= 1.0),
        super(key: key);

  @override
  _SwipeableWidgetState createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var _dxStartPosition = 0.0;
  var _dxEndsPosition = 0.0;
  var _initControllerVal;

  @override
  void initState() {
    super.initState();
    _initControllerVal = widget.height / widget.screenSize;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        if (_controller.value > _initControllerVal) {
          setState(() {});
          widget.onSwipeStartcallback(
              _controller.value > _initControllerVal + 0.1, _controller.value);
        }
        if (_controller.value == _initControllerVal) {
          widget.onSwipeStartcallback(false, 0);
        }
      });
//    _controller.addStatusListener(());

    _controller.value = _initControllerVal;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: (details) {
          setState(() {
            _dxStartPosition = details.localPosition.dx;
          });
        },
        onPanUpdate: (details) {
          final widgetSize = context.size!.width;

          // will only animate the swipe if user start the swipe in the quarter half start page of the widget
          final minimumXToStartSwiping = widgetSize * 0.25;
          if (_dxStartPosition <= minimumXToStartSwiping) {
            setState(() {
              _dxEndsPosition = details.localPosition.dx;
            });

            // update the animation value according to user's pan update
            final widgetSize = context.size!.width;
            if (_dxEndsPosition >= minimumXToStartSwiping) {
              _controller.value = ((details.localPosition.dx) / widgetSize);
            }
          }
//          widget.onSwipeStartcallback(_controller.value);
        },
        onPanEnd: (details) async {
          // checks if the right swipe that user has done is enough or not
          final delta = _dxEndsPosition - _dxStartPosition;
          final widgetSize = context.size!.width;
          final deltaNeededToBeSwiped =
              widgetSize * widget.swipePercentageNeeded!;
          if (delta > deltaNeededToBeSwiped) {
            // if it's enough, then animate to hide them
            _controller.animateTo(1.0,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn);
            widget.onSwipeCallback();
          } else {
            // if it's not enough, then animate it back to its full width
            _controller.animateTo(_initControllerVal,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn);
          }
//          widget.onSwipeStartcallback(_controller.value);
        },
        child: Container(
          height: widget.height,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _controller.value,
              heightFactor: 1.0,
              child: widget.child,
            ),
          ),
        ));
  }
}
