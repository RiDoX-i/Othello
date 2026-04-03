class Game {

  Board board;
  TypeCell currentTurn;

  PVector posBoard;
  int nbCellsX;
  int nbCellsY;

  Game() {
    posBoard = new PVector(80, 80);
    nbCellsX = 8;
    nbCellsY = 8;

    board = new Board(posBoard, nbCellsX, nbCellsY);
    setStartingPlayer(TypeCell.BLACK);
  }

  void drawIt() {
    board.drawIt();
  }

  void handleClick(int x, int y) {
    PVector cellPos = board.getCellCorrespondPos(new PVector(x, y));

    int i = int(cellPos.x);
    int j = int(cellPos.y);

    if (i >= 0 && i < nbCellsY && j >= 0 && j < nbCellsX) {
      if (board.cells[i][j] == TypeCell.VALID) {
        println("clicked cell : (" + i + ", " + j + ") - turn: " + currentTurn);
        board.updateCells(i, j);
        board.detectAndFlip(i, j); // 🔥 IMPORTANT
        changeTurn();
      }
    }
  }

  void setStartingPlayer(TypeCell player) {
    if (player == TypeCell.BLACK || player == TypeCell.WHITE) {
      currentTurn = player;
      board.setCurrentPlayer(player);
      board.refreshValidCells();
    }
  }

  void changeTurn() {
    if (currentTurn == TypeCell.WHITE) {
      currentTurn = TypeCell.BLACK;
    } else {
      currentTurn = TypeCell.WHITE;
    }

    board.setCurrentPlayer(currentTurn);
    board.refreshValidCells();
    println("next turn : " + currentTurn);
  }
}
