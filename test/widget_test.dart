



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sea_battle_cw/models/board.dart';
import 'package:sea_battle_cw/ui/widgets/board_widget.dart';

void main() {
  runApp(
      MaterialApp(
        home: MyFirstScreen(), // Кажемо: "Ось твій стартовий екран"
      )
  );
}

class MyFirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Бій!")),
      body: Center( // Центруємо нашу колонку на екрані
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Вирівнюємо елементи по центру по вертикалі
          children: [
            Text("Ваш хід!"),           // Елемент 1 (зверху)
            SizedBox(height: 20),       // Елемент 2 (просто порожній простір для відступу)
            BoardWidget(board: Board()), // Елемент 3 (Наше ігрове поле 10х10)
            SizedBox(height: 20),       // Елемент 4 (знову відступ)
            ElevatedButton(             // Елемент 5 (кнопка внизу)
              onPressed: () {},
              child: Text("Здатися"),
            ),
          ],
        ),
      ),
    );
  }
}