import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe_ui/component/Square.dart';
import 'package:tic_tac_toe_ui/model/TicTacToeMove.dart';
import 'package:tic_tac_toe_ui/component/StartupDialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TicTacToeMove> moves = [];
  String? computer;
  String? human;
  bool disableUserInteraction = true;
  Map<String, String> board = {};
  String awaitingPlayer = "X"; //x always goes first
  String message = "";

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    Timer.run(() => _promptUserToChooseXorO());
  }

  void _fetchComputersNextMove() async {
    await Future.delayed(Duration(seconds: 1)); //simulates latency
    var payload = {"player": computer, "moves": moves};

    try {
      var response = await http.post(
          Uri.parse('http://127.0.0.1:5500/next-move'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload));

      var json = jsonDecode(response.body);
      var nextMove = TicTacToeMove.fromJson(json);

      onMove(nextMove.cell);
    } catch (e) {
      inspect(e);
    }
  }

  String? findWinner(board) {
    var columns = "ABC";

    //column win
    for (var i = 0; i < columns.length; i++) {
      if (board[columns[i] + "1"] != null &&
          board[columns[i] + "1"] == board[columns[i] + "2"] &&
          board[columns[i] + "1"] == board[columns[i] + "3"]) {
        return board[columns[i] + "1"];
      }
    }

    //row win
    for (var i = 0; i < 3; i++) {
      if (board["A${i + 1}"] != null &&
          board["A${i + 1}"] == board["B${i + 1}"] &&
          board["A${i + 1}"] == board["C${i + 1}"]) {
        return board["A${i + 1}"];
      }
    }

    //descending diagnal win
    if (board["A1"] != null &&
        board["A1"] == board["B2"] &&
        board["A1"] == board["C3"]) {
      return board["A1"];
    }

    //ascending diagnal win
    if (board["A3"] != null &&
        board["A3"] == board["B2"] &&
        board["A3"] == board["C1"]) {
      return board["B2"];
    }

    return null;
  }

  void setStalemateState() {
    setState(() {
      message = "Stalemate";
      disableUserInteraction = true;
      moves = moves;
      board = board;
    });
  }

  void setWinState(String winner) {
    setState(() {
      message = (human == winner) ? "You Won!" : "You Lost :(";
      disableUserInteraction = true;
      moves = moves;
      board = board;
    });
  }

  void onMove(cell) {
    var lastPlayer = moves.isEmpty ? "O" : moves[moves.length - 1].player;
    var currentPlayer = (lastPlayer == "X") ? "O" : "X";
    moves.add(TicTacToeMove(cell, currentPlayer));
    board = {};
    for (var i = 0; i < moves.length; i++) {
      board[moves[i].cell] = moves[i].player;
    }

    var msg = (human == lastPlayer)
        ? "It's your turn!"
        : "Waiting for computer to make a move...";

    var winner = findWinner(board);
    if (winner == null && moves.length == 9) {
      setStalemateState();
      return;
    } else if (winner != null) {
      setWinState(winner);
      return;
    }

    setState(() {
      awaitingPlayer = lastPlayer;
      message = msg;
      disableUserInteraction = (human != lastPlayer);
      moves = moves;
      board = board;
    });

    if (lastPlayer == computer) {
      _fetchComputersNextMove();
    }
  }

  void _promptUserToChooseXorO() async {
    var startupDialog = StartupDialog();
    human = await startupDialog.show(context);
    computer = (human == "X") ? "O" : "X";
    var msg = (awaitingPlayer == human)
        ? "It's your turn!"
        : "Waiting for computer to make a move...";

    setState(() {
      moves = [];
      board = {};
      awaitingPlayer = "X"; //x always goes first
      message = msg;
      disableUserInteraction = (human != awaitingPlayer);
    });

    if (computer == "X") {
      _fetchComputersNextMove();
    }
  }

  void showNewGameButton() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: AbsorbPointer(
              absorbing: disableUserInteraction,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.width * 0.70,
                  child: Column(children: <Widget>[
                    Text('${this.message}',
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(height: 50),
                    Flexible(
                        child: GridView.count(
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Square(
                            cellAssignment: "A1",
                            value: board['A1'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "A2",
                            value: board['A2'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "A3",
                            value: board['A3'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "B1",
                            value: board['B1'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "B2",
                            value: board['B2'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "B3",
                            value: board['B3'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "C1",
                            value: board['C1'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "C2",
                            value: board['C2'],
                            moveCallback: onMove),
                        Square(
                            cellAssignment: "C3",
                            value: board['C3'],
                            moveCallback: onMove),
                      ],
                    ))
                  ]))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => {this.startNewGame()}),
          tooltip: 'Start a new game',
          child: const Icon(Icons.add),
        ));
  }
}
