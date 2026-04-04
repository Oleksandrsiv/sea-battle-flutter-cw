import 'package:flutter/material.dart';
import '../../models/cell.dart';

// StatelessWidget означає, що цей віджет "дурний" і не має власної пам'яті.
// Він просто малює те, що йому передали ззовні.
class CellWidget extends StatelessWidget {
  final CellStatus status;      // Статус клітинки (з твого ядра)
  final VoidCallback? onTap;    // Функція, яка викличеться при кліку

  // Конструктор
  const CellWidget({
    super.key,
    required this.status,
    this.onTap,
  });

  // Допоміжний метод: визначаємо колір квадратика на основі статусу
  Color _getCellColor() {
    switch (status) {
      case CellStatus.water:
        return Colors.blue[100]!; // Світло-синя вода
      case CellStatus.ship:
        return Colors.grey[700]!; // Сірий корабель (буде видно тільки при розстановці)
      case CellStatus.miss:
        return Colors.blue[900]!; // Темно-синій промах
      case CellStatus.hit:
        return Colors.orange;     // Помаранчеве влучання (поранення)
      case CellStatus.sunk:
        return Colors.red[800]!;  // Червоний - потоплено
    }
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector дозволяє відловлювати кліки екрану (тапи)
    return GestureDetector(
      onTap: onTap,
      // Container - це базовий "квадратик", якому можна задати розмір, колір та рамку
      child: Container(
        margin: const EdgeInsets.all(1.0), // Маленький відступ, щоб створити ефект "сітки"
        decoration: BoxDecoration(
          color: _getCellColor(),
          border: Border.all(color: Colors.blue[300]!), // Рамочка клітинки
        ),
        // Якщо клітинка поранена або промах - можна навіть намалювати іконку всередині
        child: _buildIcon(),
      ),
    );
  }

  // (Опціонально) Додаємо хрестик або крапку для краси
  Widget? _buildIcon() {
    if (status == CellStatus.hit || status == CellStatus.sunk) {
      return const Icon(Icons.close, color: Colors.white, size: 18);
    } else if (status == CellStatus.miss) {
      return const Icon(Icons.circle, color: Colors.white54, size: 10);
    }
    return null; // Нічого не малюємо для води та цілих кораблів
  }
}