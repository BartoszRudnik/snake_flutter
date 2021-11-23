import 'package:flutter/material.dart';
import 'package:snake_flutter/inactive_control_button.dart';

import 'active_control_button.dart';
import 'direction.dart';

class ControlPanel extends StatelessWidget {
  final void Function(Direction direction) onTapped;
  final Direction previousDirection;

  const ControlPanel({
    Key? key,
    required this.onTapped,
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
                previousDirection == Direction.left || previousDirection == Direction.right
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_left, color: Colors.grey[850]),
                      )
                    : ActiveControlButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          onTapped(Direction.left);
                        },
                      ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                previousDirection == Direction.up || previousDirection == Direction.down
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_drop_up_sharp, color: Colors.grey[850]),
                      )
                    : ActiveControlButton(
                        icon: const Icon(Icons.arrow_drop_up_sharp),
                        onPressed: () {
                          onTapped(Direction.up);
                        },
                      ),
                const SizedBox(
                  height: 75.0,
                ),
                previousDirection == Direction.down || previousDirection == Direction.up
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey[850]),
                      )
                    : ActiveControlButton(
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        onPressed: () {
                          onTapped(Direction.down);
                        },
                      ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                previousDirection == Direction.right || previousDirection == Direction.left
                    ? InActiveControlButton(
                        icon: Icon(Icons.arrow_right, color: Colors.grey[850]),
                      )
                    : ActiveControlButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          onTapped(Direction.right);
                        },
                      ),
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
