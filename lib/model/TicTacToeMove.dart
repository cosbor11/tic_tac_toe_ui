class TicTacToeMove {
  String cell;
  String player;

  TicTacToeMove.fromJson(Map<String, dynamic> json)
      : cell = json['cell'],
        player = json['player'];

  Map<String, dynamic> toJson() {
    return {'cell': cell, 'player': player};
  }

  TicTacToeMove(this.cell, this.player);
}
