import 'package:flutter/material.dart';
import '../../models/board.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final Board board; // Передаємо сюди об'єкт нашої дошки з ядра
  final Function(int x, int y)? onCellTapped; // Функція, що поверне координати кліку

  const BoardWidget({
    super.key,
    required this.board,
    this.onCellTapped,
  });

  @override
  Widget build(BuildContext context) {
    // AspectRatio робить так, щоб наше поле ЗАВЖДИ було ідеальним квадратом (співвідношення 1:1),
    // незалежно від того, який екран у телефона (широкий чи витягнутий).
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2), // Зовнішня рамка всього поля
        ),
        // GridView.builder - це наш конвеєр для створення сітки
        child: GridView.builder(
          // Ці два рядки дуже важливі, щоб сітка не намагалася прокручуватися (скролитися)
          // і займала рівно стільки місця, скільки їй потрібно.
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,

          // Кажемо: "Всього у нас 100 клітинок" (розмір поля * розмір поля)
          itemCount: board.size * board.size,

          // Налаштовуємо колонки: фіксовано 10 штук у ряд
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: board.size, // 10
          ),

          // Цей метод викликається 100 разів (від index = 0 до index = 99)
          itemBuilder: (context, index) {
            // МАТЕМАТИЧНА МАГІЯ: Перетворюємо порядковий номер (0-99) у координати X та Y
            int x = index % board.size;    // Остача від ділення на 10 (дасть числа від 0 до 9)
            int y = index ~/ board.size;   // Цілочисельне ділення на 10 (дасть рядок від 0 до 9)

            // Дістаємо статус конкретної клітинки з нашої моделі Board
            var cellStatus = board.grid[y][x].status;

            // Повертаємо нашу "детальку" CellWidget, яку ми написали раніше!
            return CellWidget(
              status: cellStatus,
              onTap: () {
                // Якщо передали функцію натискання - викликаємо її та віддаємо їй X і Y
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