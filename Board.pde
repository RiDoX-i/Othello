// this class will hold attributes and methods for the related to cells [cite: 1]

// constants of the Cells [cite: 1]
enum TypeCell {
  EMPTY,
  BLACK,
  WHITE,
  VALID
}

class Board {

  // cells [cite: 2]
  TypeCell cells[][];
  int cellSize; [cite: 2]
  PVector position;

  PImage bg;

  TypeCell currentPlayer;

  Board(){}

  Board(PVector pos, int nbX, int nbY) {
    position = pos.copy(); [cite: 3]
    cellSize = 80; [cite: 3]
    cells = new TypeCell[nbY][nbX]; [cite: 3]
    currentPlayer = TypeCell.BLACK; [cite: 3]
    setBoard(); [cite: 3]
  } [cite: 4]

  // setting up the board for Othello [cite: 4]
  void setBoard() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        cells[i][j] = TypeCell.EMPTY; [cite: 5]
      }
    }

    // setting the 4 first pieces in the middle of the board [cite: 5]
    int midI = cells.length / 2 - 1; [cite: 6]
    int midJ = cells[0].length / 2 - 1; [cite: 6]

    cells[midI][midJ] = TypeCell.WHITE; [cite: 6]
    cells[midI][midJ + 1] = TypeCell.BLACK; [cite: 7]
    cells[midI + 1][midJ] = TypeCell.BLACK; [cite: 7]
    cells[midI + 1][midJ + 1] = TypeCell.WHITE; [cite: 8]
  } [cite: 8]

  /*----------------------------------------FONCTIONS RETURNING INFORMATIONS ABOUT CELLS---------------------------------------*/

  // gets the cell center [cite: 8]
  PVector getCellCenter(int i, int j) {
    return new PVector(
      position.x + j * cellSize + (cellSize * 0.5),
      position.y + i * cellSize + (cellSize * 0.5)
    ); [cite: 9]
  }

  // gets the corresponding cell according the position in game window [cite: 9]
  PVector getCellCorrespondPos(PVector pos) {
    return new PVector(
      int((pos.y - position.y) / cellSize),
      int((pos.x - position.x) / cellSize)
    ); [cite: 10]
  }

  /*--------------------------------UPDATING THE CELLS ----------------------------------*/
  void updateCells(int i, int j) {
    cells[i][j] = currentPlayer; [cite: 11]
  }

  void flipPiece(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length) {
      return; [cite: 12]
    }

    if (cells[i][j] == TypeCell.BLACK) {
      cells[i][j] = TypeCell.WHITE; [cite: 13]
    } else if (cells[i][j] == TypeCell.WHITE) {
      cells[i][j] = TypeCell.BLACK; [cite: 14]
    }
  }

  void detectPiecesToFlip(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length) {
      return; [cite: 15]
    }

    TypeCell placedPlayer = cells[i][j]; [cite: 16]

    if (placedPlayer != TypeCell.BLACK && placedPlayer != TypeCell.WHITE) {
      return; [cite: 16]
    }

    TypeCell opponentPlayer = placedPlayer == TypeCell.WHITE ? TypeCell.BLACK : TypeCell.WHITE; [cite: 17]
    
    for (int dirI = -1; dirI <= 1; dirI++) {
      for (int dirJ = -1; dirJ <= 1; dirJ++) {
        if (dirI == 0 && dirJ == 0) {
          continue; [cite: 18]
        }

        int nextI = i + dirI; [cite: 19]
        int nextJ = j + dirJ; [cite: 19]
        int piecesToFlip = 0; [cite: 19]

        while (nextI >= 0 && nextI < cells.length && nextJ >= 0 && nextJ < cells[0].length && cells[nextI][nextJ] == opponentPlayer) {
          piecesToFlip++; [cite: 20]
          nextI += dirI; [cite: 20]
          nextJ += dirJ;
        }

        if (piecesToFlip > 0 && nextI >= 0 && nextI < cells.length && nextJ >= 0 && nextJ < cells[0].length && cells[nextI][nextJ] == placedPlayer) {
          for (int step = 1; step <= piecesToFlip; step++) {
            flipPiece(i + dirI * step, j + dirJ * step); [cite: 21]
          }
        }
      }
    }
  }

  // player's related functions
  void setCurrentPlayer(TypeCell player) {
    if (player == TypeCell.BLACK || player == TypeCell.WHITE) {
      currentPlayer = player; [cite: 22]
    }
  }

  TypeCell getCurrentPlayer() {
    return currentPlayer; [cite: 23]
  }

  // functions related to valid moves
  void clearValidCells() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (cells[i][j] == TypeCell.VALID) {
          cells[i][j] = TypeCell.EMPTY; [cite: 24]
        }
      }
    }
  }

  boolean isValidMove(int i, int j) {
    if (i < 0 || i >= cells.length || j < 0 || j >= cells[0].length || cells[i][j] != TypeCell.EMPTY) {
      return false; [cite: 25]
    }

    TypeCell opponentPlayer = currentPlayer == TypeCell.WHITE ? TypeCell.BLACK : TypeCell.WHITE; [cite: 26]
    
    for (int dirI = -1; dirI <= 1; dirI++) {
      for (int dirJ = -1; dirJ <= 1; dirJ++) {
        if (dirI == 0 && dirJ == 0) {
          continue; [cite: 27]
        }

        int nextI = i + dirI; [cite: 28]
        int nextJ = j + dirJ; [cite: 28]
        boolean foundOpponentPiece = false; [cite: 28]

        while (nextI >= 0 && nextI < cells.length && nextJ >= 0 && nextJ < cells[0].length && cells[nextI][nextJ] == opponentPlayer) {
          foundOpponentPiece = true; [cite: 29]
          nextI += dirI; [cite: 29]
          nextJ += dirJ;
        }

        if (foundOpponentPiece && nextI >= 0 && nextI < cells.length && nextJ >= 0 && nextJ < cells[0].length && cells[nextI][nextJ] == currentPlayer) {
          return true; [cite: 30]
        }
      }
    }
    return false; [cite: 31]
  }

  void refreshValidCells() {
    clearValidCells(); [cite: 32]

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (isValidMove(i, j)) {
          cells[i][j] = TypeCell.VALID; [cite: 32]
        }
      }
    }
  }

  // NOUVELLE FONCTION : Vérifie s'il reste au moins un coup possible
  boolean hasValidMove() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (cells[i][j] == TypeCell.VALID) return true;
      }
    }
    return false;
  }

  // NOUVELLE FONCTION : Compte les pions de chaque couleur
  int getScore(TypeCell type) {
    int count = 0;
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (cells[i][j] == type) count++;
      }
    }
    return count;
  }

  void drawIt() {
    background(20, 120, 40); [cite: 33]
    rectMode(CENTER); [cite: 33]
    stroke(0, 0, 0, 50); [cite: 33]

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {

        fill(255, 255, 255, 30); [cite: 34]
        rect(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize, cellSize); [cite: 34]

        if (cells[i][j] == TypeCell.BLACK) {
          fill(20); [cite: 35]
          ellipse(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize * 0.75, cellSize * 0.75); [cite: 36]
        }

        if (cells[i][j] == TypeCell.WHITE) {
          fill(245); [cite: 37]
          ellipse(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize * 0.75, cellSize * 0.75); [cite: 38]
        }

        // MODIFICATION : L'indicateur change de couleur selon le joueur actuel
        if (cells[i][j] == TypeCell.VALID) {
          if (currentPlayer == TypeCell.BLACK) {
            fill(0, 0, 0, 100); // Noir discret
          } else {
            fill(255, 255, 255, 100); // Blanc discret
          }
          ellipse(getCellCenter(i, j).x, getCellCenter(i, j).y, cellSize * 0.25, cellSize * 0.25);
        }
      }
    }
  }
}
