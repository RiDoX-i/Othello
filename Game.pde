class Game {
  Board board;
  Menu menu; 
  TypeCell currentTurn;
  PVector posBoard;
  int nbCellsX;
  int nbCellsY;
  int endGameStartTime;

  Game() {
    posBoard = new PVector(80, 80);
    nbCellsX = 8;
    nbCellsY = 8;
    endGameStartTime = -1;
    board = new Board(posBoard, nbCellsX, nbCellsY);
    setStartingPlayer(TypeCell.BLACK);
  }

  void restart() {
    endGameStartTime = -1;
    board = new Board(posBoard, nbCellsX, nbCellsY);
    setStartingPlayer(TypeCell.BLACK);
  }

  void drawIt() {
    board.drawIt();
    drawCurrentTurnWidget();
    if (board.isGameFinished()) {
      drawEndGameWidget();
    }
  }

  void handleClick(int x, int y) {
    if (board.isGameFinished()) {
      return;
    }
    PVector cellPos = board.getCellCorrespondPos(new PVector(x, y));
    int i = int(cellPos.x);
    int j = int(cellPos.y);
    if (i >= 0 && i < nbCellsY && j >= 0 && j < nbCellsX) {
      if (board.cells[i][j] == TypeCell.VALID) {
        println("clicked cell : (" + i + ", " + j + ") - turn: " + currentTurn);
        board.updateCells(i, j);
        menu.returnStat = 1;
        board.detectPiecesToFlip(i, j);
        board.resetSkippedTurns();
        changeTurn();
      }
    }
  }

  void setStartingPlayer(TypeCell player) {
    if (player == TypeCell.BLACK || player == TypeCell.WHITE) {
      currentTurn = player;
      board.setCurrentPlayer(player);
      board.refreshValidCells();
      board.skipTurns();
      currentTurn = board.getCurrentPlayer();
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
    board.skipTurns();
    currentTurn = board.getCurrentPlayer();
    println("next turn : " + currentTurn);
  }

  void drawCurrentTurnWidget() {
    rectMode(CENTER);
    stroke(255);
    fill(20, 120, 40);
    rect(width * 0.5, 40, 180, 50, 12);
    if (currentTurn == TypeCell.WHITE) {
      fill(245);
    } else {
      fill(20);
    }
    ellipse(width * 0.5 - 50, 40, 26, 26);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Current turn", width * 0.5 + 20, 40);
  }

  void drawEndGameWidget() {
    if (endGameStartTime == -1) {
      endGameStartTime = millis();
    }
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    fill(0, 0, 0, 180);
    noStroke();
    rect(width * 0.5, height * 0.5, 420, 120, 18);
    fill(255);
    textSize(28);
    text(board.getWinnerMessage(), width * 0.5, height * 0.5);
    if (millis() - endGameStartTime > 5000) {
      restart();
      return;
    }
  }
}
