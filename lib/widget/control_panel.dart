import 'package:flutter/material.dart';
import 'package:snake_flutter/widget/button/inactive_control_button.dart';
import '../utils/direction.dart';

class ControlPanel extends StatelessWidget {
  final Direction previousDirection;

  const ControlPanel({
    Key? key,
    required this.previousDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                previousDirection == Direction.left
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_left, color: Colors.grey[850]),
                      )
                    : Container()
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                previousDirection == Direction.up
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_drop_up_sharp, color: Colors.grey[850]),
                      )
                    : Container(),
                const SizedBox(
                  height: 75.0,
                ),
                previousDirection == Direction.down
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey[850]),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                previousDirection == Direction.right
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_right, color: Colors.grey[850]),
                      )
                    : Container(),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
