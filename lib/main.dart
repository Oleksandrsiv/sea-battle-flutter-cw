import 'package:flutter/material.dart';
import 'package:sea_battle_cw/ui/screens/main_screen.dart';

import 'core/engine/game_engine.dart';
import 'core/controllers/game_controller.dart';

import 'core/engine/state/player_turn_state.dart';
import 'core/fleet_builder/builder/auto_builder.dart';
import 'core/fleet_builder/builder/director.dart';
import 'ui/screens/setup_screen.dart';
import 'ui/screens/battle_screen.dart';

void main() {
  runApp(const SeaBattleApp());
}

class SeaBattleApp extends StatelessWidget {
  const SeaBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sea Battle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainGameApp(),
    );
  }
}

// Screens
enum AppScreen { menu, setup, battle }

class MainGameApp extends StatefulWidget {
  const MainGameApp({super.key});

  @override
  State<MainGameApp> createState() => _MainGameAppState();
}

class _MainGameAppState extends State<MainGameApp> {
  AppScreen _currentScreen = AppScreen.menu;

  late GameEngine _engine;
  late GameController _controller;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _engine = GameEngine();
    _controller = GameController(engine: _engine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(  // SafeArea guarantees that our content won't be hidden behind notches or system UI
        child: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {

      case AppScreen.menu:
        return MainMenuScreen(
          onPlayPressed: () {
            setState(() {
              _currentScreen = AppScreen.setup; // tap play => go to setup screen
            });
          },
        );

      case AppScreen.setup:
        return SetupScreen(
          controller: _controller,
          onStartBattle: () {
            setState(() {
              _controller.engine.changeState(PlayerTurnState());

              var director = Director();
              var autoBuilder = RandomFleetBuilder();
              director.constructStandardFleet(autoBuilder);

              _controller.engine.botBoard = autoBuilder.getResult();

              _currentScreen = AppScreen.battle;
            });
          },
        );

      case AppScreen.battle:
        return BattleScreen(
          controller: _controller,
          onRestart: () {
            setState(() {
              _startNewGame();
              _currentScreen = AppScreen.setup;
            });
          },
        );
    }
  }
}