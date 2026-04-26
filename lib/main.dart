import 'package:flutter/material.dart';
import 'package:sea_battle_cw/ui/screens/main_screen.dart';
import 'package:sea_battle_cw/ui/widgets/board_widget.dart';
import 'models/board.dart';



void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainMenuScreen(super.key, onPlayPressed: null), // Просто для тесту, потім замінимо на нормальний екран гри
  ));
}

class BoardTestScreen extends StatelessWidget {
  const BoardTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Створюємо тестову дошку (вона спочатку складатиметься тільки з води)
    final testBoard = Board();

    return Scaffold(
      appBar: AppBar(title: const Text('Тест поля 10х10')),
      body: Center(
        // Padding додає відступи по краях, щоб поле не прилипало до стінок екрану
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BoardWidget(
            board: testBoard,
            onCellTapped: (x, y) {
              // Просто друкуємо в консоль, щоб перевірити, чи правильно рахуються координати
              print('Клік по клітинці: X=$x, Y=$y');
            },
          ),
        ),
      ),
    );
  }
}