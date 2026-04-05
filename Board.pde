// Board.pde  –  holds all cell-level data and logic.
// RULE: cells are ONLY ever modified inside this class.

enum TypeCell {
  EMPTY,
  BLACK,
  WHITE,
  VALID
}

class Board {

  // cells
  TypeCell cells[][];
  TypeCell save[][]; // ***** used to save the n-1 move

  int cellSize;
  PVector position;

  PImage bg;

  TypeCell currentPlayer;
  int skippedTurns;

  // Memorises the last move as (i, j) so Menu can ask for an undo
  PVector lastMove;

  Board() {}

  Board(PVector pos, int nbX, int nbY) {
    position    = pos.copy();
    cellSize    = 80;
    cells       = new TypeCell[nbY][nbX];
    save       = new TypeCell[nbY][nbX]; // *****

    currentPlayer = TypeCell.BLACK;
    skippedTurns  = 0;
    lastMove      = null;
    setBoard(cells,save);
    
  }

  // -------------------------------------------------------------------------
  // Setting up / resetting the board
  // -------------------------------------------------------------------------
  void setBoard(TypeCell matrix[][],TypeCell save[][] ) {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        matrix[i][j] = TypeCell.EMPTY;
      }
    }
    int midI = cells.length    / 2 - 1;
    int midJ = cells[0].length / 2 - 1;
    matrix[midI][midJ]         = TypeCell.WHITE;
    matrix[midI][midJ + 1]     = TypeCell.BLACK;
    matrix[midI + 1][midJ]     = TypeCell.BLACK;
    matrix[midI + 1][midJ + 1] = TypeCell.WHITE;
    lastMove = null;
    
    // initislise save
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        save[x][y] = cells[x][y];
      }
    }
  }

  /*----------------------------------------FONCTIONS RETURINING INFORMATIONS ABOUT CELLS---------------------------------------*/

  PVector getCellCenter(int i, int j) {
    return new PVector(
      position.x + j * cellSize + (cellSize * 0.5),
      position.y + i * cellSize + (cellSize * 0.5)
    );
  }

  PVector getCellCorrespondPos(PVector pos) {
    return new PVector(
      int((pos.y - position.y) / cellSize),
      int((pos.x - position.x) / cellSize)
    );
  }

/*-----------------------------------------------UPDATING THE CELLS ----------------------------------------------------------------*/

 
  void loadsave() {
    // loading n-1 board
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
         cells[x][y]=save[x][y];
    }
    }   
  }

  
  void updateCells(int i, int j) {
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
        save[x][y] = cells[x][y];
      }
    }   
    cells[i][j] = currentPlayer;
    lastMove     = new PVector(i, j);   // memorise for potential undo
  }

  void flipPiece(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length) return;
    if      (cells[i][j] == TypeCell.BLACK) cells[i][j] = TypeCell.WHITE;
    else if (cells[i][j] == TypeCell.WHITE) cells[i][j] = TypeCell.BLACK;
  }

  void detectPiecesToFlip(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length) return;

    TypeCell placedPlayer = cells[i][j];
    if (placedPlayer != TypeCell.BLACK && placedPlayer != TypeCell.WHITE) return;

    TypeCell opponentPlayer = placedPlayer == TypeCell.WHITE ? TypeCell.BLACK : TypeCell.WHITE;

    for (int dirI = -1; dirI <= 1; dirI++) {
      for (int dirJ = -1; dirJ <= 1; dirJ++) {
        if (dirI == 0 && dirJ == 0) continue;

        int nextI        = i + dirI;
        int nextJ        = j + dirJ;
        int piecesToFlip = 0;

        while (nextI >= 0 && nextI < cells.length &&
               nextJ >= 0 && nextJ < cells[0].length &&
               cells[nextI][nextJ] == opponentPlayer) {
          piecesToFlip++;
          nextI += dirI;
          nextJ += dirJ;
        }

        if (piecesToFlip > 0 &&
            nextI >= 0 && nextI < cells.length &&
            nextJ >= 0 && nextJ < cells[0].length &&
            cells[nextI][nextJ] == placedPlayer) {
          for (int step = 1; step <= piecesToFlip; step++) {
            flipPiece(i + dirI * step, j + dirJ * step);
          }
        }
      }
    }
  }

 
  void setCurrentPlayer(TypeCell player) {
    if (player == TypeCell.BLACK || player == TypeCell.WHITE) {
      currentPlayer = player;
    }
  }

  TypeCell getCurrentPlayer() { return currentPlayer; }

  void clearValidCells() {
    for (int i = 0; i < cells.length; i++)
      for (int j = 0; j < cells[i].length; j++)
        if (cells[i][j] == TypeCell.VALID) cells[i][j] = TypeCell.EMPTY;
  }

  boolean isValidMove(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length ||
        cells[i][j] != TypeCell.EMPTY) return false;

    TypeCell opponentPlayer = currentPlayer == TypeCell.WHITE ? TypeCell.BLACK : TypeCell.WHITE;

    for (int dirI = -1; dirI <= 1; dirI++) {
      for (int dirJ = -1; dirJ <= 1; dirJ++) {
        if (dirI == 0 && dirJ == 0) continue;

        int nextI = i + dirI, nextJ = j + dirJ;
        boolean foundOpponent = false;

        while (nextI >= 0 && nextI < cells.length &&
               nextJ >= 0 && nextJ < cells[0].length &&
               cells[nextI][nextJ] == opponentPlayer) {
          foundOpponent = true;
          nextI += dirI;
          nextJ += dirJ;
        }

        if (foundOpponent &&
            nextI >= 0 && nextI < cells.length &&
            nextJ >= 0 && nextJ < cells[0].length &&
            cells[nextI][nextJ] == currentPlayer) return true;
      }
    }
    return false;
  }

  void refreshValidCells() {
    clearValidCells();
    for (int i = 0; i < cells.length; i++)
      for (int j = 0; j < cells[i].length; j++)
        if (isValidMove(i, j)) cells[i][j] = TypeCell.VALID;
  }

  boolean checkMatriceCells() {
    for (int i = 0; i < cells.length; i++)
      for (int j = 0; j < cells[i].length; j++)
        if (cells[i][j] == TypeCell.VALID) return false;
    return true;
  }

  boolean skipTurns() {
    if (!checkMatriceCells()) return false;
    skippedTurns++;
    currentPlayer = currentPlayer == TypeCell.WHITE ? TypeCell.BLACK : TypeCell.WHITE;
    refreshValidCells();
    if (checkMatriceCells()) skippedTurns++;
    return true;
  }

  void resetSkippedTurns() { skippedTurns = 0; }

  boolean isBoardFull() {
    for (int i = 0; i < cells.length; i++)
      for (int j = 0; j < cells[i].length; j++)
        if (cells[i][j] == TypeCell.EMPTY || cells[i][j] == TypeCell.VALID) return false;
    return true;
  }

  boolean isGameFinished() {
    return isBoardFull() || skippedTurns >= 2;
  }

  TypeCell getWinner() {
    int blackCount = 0, whiteCount = 0;
    for (int i = 0; i < cells.length; i++)
      for (int j = 0; j < cells[i].length; j++) {
        if (cells[i][j] == TypeCell.BLACK) blackCount++;
        if (cells[i][j] == TypeCell.WHITE) whiteCount++;
      }
    if (whiteCount > blackCount) return TypeCell.WHITE;
    if (blackCount > whiteCount) return TypeCell.BLACK;
    return TypeCell.EMPTY;
  }

  String getWinnerMessage() {
    TypeCell winner = getWinner();
    if (winner == TypeCell.WHITE) return "Le joueur white a gagné";
    if (winner == TypeCell.BLACK) return "Le joueur black a gagné";
    return "Egalité";
  }


  void drawIt() {
    background(20, 120, 40);
    rectMode(CENTER);
    stroke(0, 0, 0, 50);

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        fill(255, 255, 255, 30);
        rect(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize, cellSize);

        if (cells[i][j] == TypeCell.BLACK) {
          fill(20);
          ellipse(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize * 0.75, cellSize * 0.75);
        }
        if (cells[i][j] == TypeCell.WHITE) {
          fill(245);
          ellipse(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize * 0.75, cellSize * 0.75);
        }
        if (cells[i][j] == TypeCell.VALID) {
          fill(255, 255, 0, 160);
          ellipse(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize * 0.20, cellSize * 0.20);
        }
      }
    }
  }
}
