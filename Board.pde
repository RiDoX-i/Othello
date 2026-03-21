// this class will hold attributes and methods for the related to cells

// constants of the Cells
enum TypeCell {
  EMPTY,
  BLACK,
  WHITE,
  VALID
}

class Board {

  // cells
  TypeCell cells[][];
  int cellSize;
  PVector position;

  PImage bg;

  TypeCell currentPlayer;

  Board(){}

  Board(PVector pos, int nbX, int nbY) {
    position = pos.copy();
    cellSize = 80;
    cells = new TypeCell[nbY][nbX];
    currentPlayer = TypeCell.BLACK;
    setBoard();
  }

  // setting up the board for Othello
  void setBoard() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        cells[i][j] = TypeCell.EMPTY;
      }
    }

    // setting the 4 first pieces in the middle of the board

    int midI = cells.length / 2 - 1;
    int midJ = cells[0].length / 2 - 1;

    cells[midI][midJ] = TypeCell.WHITE;
    cells[midI][midJ + 1] = TypeCell.BLACK;
    cells[midI + 1][midJ] = TypeCell.BLACK;
    cells[midI + 1][midJ + 1] = TypeCell.WHITE;
  }

  /*----------------------------------------FONCTIONS RETURINING INFORMATIONS ABOUT CELLS---------------------------------------*/

  // gets the cell center
  PVector getCellCenter(int i, int j) {
    return new PVector(
      position.x + j * cellSize + (cellSize * 0.5),
      position.y + i * cellSize + (cellSize * 0.5)
    );
  }

  // gets the corresponding cell according the position in game window
  PVector getCellCorrespondPos(PVector pos) {
    return new PVector(
      int((pos.y - position.y) / cellSize),
      int((pos.x - position.x) / cellSize)
    );
  }

  /*--------------------------------UPDATING THE CELLS ----------------------------------*/
  void updateCells(int i, int j) {
    cells[i][j] = currentPlayer;
  }

// player related functions
// player turn
  void setCurrentPlayer(TypeCell player) {
    if (player == TypeCell.BLACK || player == TypeCell.WHITE) {
      currentPlayer = player;
    }
  }

  TypeCell getCurrentPlayer() {
    return currentPlayer;
  }

// functions related to valid moves

  void clearValidCells() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (cells[i][j] == TypeCell.VALID) {
          cells[i][j] = TypeCell.EMPTY;
        }
      }
    }
  }

// this function checks if the move is valid according to the rules of Othello
  boolean isValidMove(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length || cells[i][j] != TypeCell.EMPTY) {
      return false;
    }

    TypeCell opponentPlayer = currentPlayer == TypeCell.WHITE ? TypeCell.BLACK : TypeCell.WHITE;

    for (int dirI = -1; dirI <= 1; dirI++) {
      for (int dirJ = -1; dirJ <= 1; dirJ++) {
        if (dirI == 0 && dirJ == 0) {
          continue;
        }

        int nextI = i + dirI;
        int nextJ = j + dirJ;
        boolean foundOpponentPiece = false;

        while (nextI >= 0 && nextI < cells.length && nextJ >= 0 && nextJ < cells[0].length && cells[nextI][nextJ] == opponentPlayer) {
          foundOpponentPiece = true;
          nextI += dirI;
          nextJ += dirJ;
        }

        if (foundOpponentPiece && nextI >= 0 && nextI < cells.length && nextJ >= 0 && nextJ < cells[0].length && cells[nextI][nextJ] == currentPlayer) {
          return true;
        }
      }
    }

    return false;
  }

  void refreshValidCells() {
    clearValidCells();

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (isValidMove(i, j)) {
          cells[i][j] = TypeCell.VALID;
        }
      }
    }
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
