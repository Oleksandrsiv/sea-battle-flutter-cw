import 'package:flutter/material.dart';
import '../../models/board.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final Function(int x, int y)? onCellTapped;
  final bool hideShips;

  const BoardWidget({
    super.key,
    required this.board,
    this.onCellTapped,
    this.hideShips = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,

          itemCount: board.size * board.size,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: board.size, // 10
          ),

          itemBuilder: (context, index) {

            int x = index % board.size;
            int y = index ~/ board.size;

            var cellStatus = board.grid[y][x].status;

            return CellWidget(
              status: cellStatus,
              hideShip: hideShips,
              onTap: () {
                if (onCellTapped != null) {
                  onCellTapped!(x, y);
                }
              },
            );
          },
        ),
      ),
    );
  }
}