import 'package:flutter/material.dart';

import '../../core/controllers/game_controller.dart';
import '../../core/engine/state/setup_state.dart';
import '../widgets/board_widget.dart';

class SetupScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback onStartBattle;

  const SetupScreen({
    super.key,
    required this.controller,
    required this.onStartBattle,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final engine = controller.engine;
        final currentState = engine.currentState;

        if (currentState is! SetupState) {
          return const Scaffold(
            body: Center(child: Text("downloading...")),
          );
        }

        final setupState = currentState;
        final currentShip = setupState.currentShip;
        final isFleetReady = currentShip == null;

        return Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            title: const Text('Prepare your fleet'),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Info about current ship and orientation
              Container(
                padding: const EdgeInsets.all(16),
                child: isFleetReady
                    ? const Text(
                  'Fleet is ready! Press "TO BATTLE!" to start the game.',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )
                    : Text(
                  'Ставимо: ${currentShip.name} (${currentShip.size} палуби)\n'
                      'Орієнтація: ${setupState.isHorizontal ? "Горизонтальна" : "Вертикальна"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              // Player board (boardwdget)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BoardWidget(
                  board: engine.playerBoard,
                  onCellTapped: isFleetReady
                      ? null // if fleet is ready, disable tapping
                      : (x, y) {
                    controller.handleTap(x, y);
                  },
                ),
              ),

              // Buttons for rotating ship and starting battle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Кнопка повороту корабля
                    ElevatedButton.icon(
                      onPressed: isFleetReady
                          ? null
                          : () {
                        setupState.isHorizontal = !setupState.isHorizontal;
                        controller.update();
                      },
                      icon: const Icon(Icons.rotate_right),
                      label: const Text('rotate'),
                    ),

                    // button 'TO BATTLE!'
                    ElevatedButton(
                      onPressed: isFleetReady ? onStartBattle : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: const Text('TO BATTLE!'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}