import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<String> board;
  bool xTurn = true; // X starts first
  String winner = '';

  @override
  void initState() {
    super.initState();
    board = List.filled(9, '');
  }

  void _handleTap(int index) {
    if (board[index] != '' || winner != '') {
      // Tile already filled or game ended
      return;
    }
    setState(() {
      board[index] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      winner = _checkWinner();
    });
  }

  String _checkWinner() {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      if (board[line[0]] != '' &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        return board[line[0]]; // Winner
      }
    }

    if (!board.contains('')) {
      return 'Draw';
    }

    return '';
  }

  Widget _buildTile(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            board[index],
            style: const TextStyle(fontSize: 72),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          winner != ''
              ? Text(
                  winner == 'Draw' ? 'It\'s a Draw!' : '$winner Wins!',
                  style: const TextStyle(fontSize: 32),
                )
              : Text(
                  '${xTurn ? 'X' : 'O'}\'s Turn',
                  style: const TextStyle(fontSize: 32),
                ),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, index) => _buildTile(index),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                board = List.filled(9, '');
                winner = '';
                xTurn = true;
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
