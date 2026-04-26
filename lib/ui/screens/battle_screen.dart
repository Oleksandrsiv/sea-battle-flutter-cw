import 'package:flutter/material.dart';

import '../../core/controllers/game_controller.dart';
import '../../core/engine/state/game_over_state.dart';

import '../widgets/board_widget.dart';

class BattleScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback onRestart;

  const BattleScreen({
    super.key,
    required this.controller,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final engine = controller.engine;
        final stateName = engine.currentStateName;

        final isGameOver = engine.currentState is GameOverState;

        return Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            title: const Text('Sea Battle'),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Column(
            children: [
              // check current state (win/lose, player's/bot's turn)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: isGameOver ? Colors.yellow.shade300 : Colors.white,
                child: Text(
                  stateName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isGameOver ? Colors.red.shade900 : Colors.black87,
                  ),
                ),
              ),

              // Enemy field (Player shoots here)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Enemy field', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BoardWidget(
                        board: engine.botBoard,
                        hideShips: true,
                        onCellTapped: isGameOver
                            ? null // game end => disable taps
                            : (x, y) {
                          controller.handleTap(x, y);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 3, color: Colors.blueGrey),

              // Player`s field (Bot shoots here)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Your field', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Expanded(
                      child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BoardWidget(
                        board: engine.playerBoard,
                        onCellTapped: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // restart button
              if (isGameOver)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: onRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Play again', style: TextStyle(fontSize: 20)),
                  ),
                ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}