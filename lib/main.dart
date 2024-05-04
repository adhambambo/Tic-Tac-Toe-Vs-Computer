import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> board;
  late bool isPlayer1Turn;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.generate(3, (_) => ''));
      isPlayer1Turn = true;
    });
  }

  void makeMove(int row, int col) {
    if (board[row][col] == '' && !checkWinner() && !isBoardFull()) {
      setState(() {
        board[row][col] = 'X';
        isPlayer1Turn = false;
      });

      // Check for a winner after player's move
      if (checkWinner()) {
        showGameOverDialog('Player');
        return;
      }

      // Computer's turn
      if (!isBoardFull()) {
        Future.delayed(Duration(milliseconds: 500), () {
          computerMove();
          // Check for a winner after computer's move
          if (checkWinner()) {
            showGameOverDialog('Computer');
          }
        });
      }
    }
  }

  void computerMove() {
    // Simple computer move: choose a random empty cell
    List<int> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          emptyCells.add(i * 3 + j);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyCells.length);
      int selectedCell = emptyCells[randomIndex];
      int row = selectedCell ~/ 3;
      int col = selectedCell % 3;

      setState(() {
        board[row][col] = 'O';
        isPlayer1Turn = true;
      });
    }
  }

  bool checkWinner() {
    // Check rows, columns, and diagonals for a winner
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        return true; // Row winner
      }
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        return true; // Column winner
      }
    }
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      return true; // Diagonal winner
    }
    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      return true; // Diagonal winner
    }
    return false;
  }

  bool isBoardFull() {
    return board.every((row) => row.every((cell) => cell != ''));
  }

  void showGameOverDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Game Over',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            '$winner wins!',
            style: TextStyle(color: Colors.green),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe by Adham'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
    
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int j = 0; j < 3; j++)
                    GestureDetector(
                      onTap: () => makeMove(i, j),
                      child: Container(
                        width: 100.0,
                        height: 125.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Center(
                          child: Text(
                            board[i][j],
                            style: TextStyle(
                              fontSize: 44.0,
                              color:
                                  board[i][j] == 'X' ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
