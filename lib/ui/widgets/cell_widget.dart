import 'package:flutter/material.dart';
import '../../models/cell.dart';


class CellWidget extends StatelessWidget {
  final CellStatus status;
  final VoidCallback? onTap;
  final bool hideShip;

  const CellWidget({
    super.key,
    required this.status,
    this.onTap,
    this.hideShip = false,
  });

  Color _getCellColor() {
    if (status == CellStatus.ship && hideShip) {
      return Colors.blue.shade100;
    }

    switch (status) {
      case CellStatus.water:
        return Colors.blue[100]!;
      case CellStatus.ship:
        return Colors.grey[700]!;
      case CellStatus.miss:
        return Colors.blue[900]!;
      case CellStatus.hit:
        return Colors.orange;
      case CellStatus.sunk:
        return Colors.red[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: _getCellColor(),
          border: Border.all(color: Colors.blue[300]!),
        ),
        child: _buildIcon(),
      ),
    );
  }


  Widget? _buildIcon() {
    if (status == CellStatus.hit || status == CellStatus.sunk) {
      return const Icon(Icons.close, color: Colors.white, size: 18);
    } else if (status == CellStatus.miss) {
      return const Icon(Icons.circle, color: Colors.white54, size: 10);
    }
    return null;
  }
}