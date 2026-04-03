class Game {

  Board board;
  TypeCell currentTurn;

  PVector posBoard;
  int nbCellsX;
  int nbCellsY;
  
  boolean gameOver = false;

  Game() {
    posBoard = new PVector(80, 80);
    nbCellsX = 8;
    nbCellsY = 8;
    board = new Board(posBoard, nbCellsX, nbCellsY); [cite: 42, 43]
    setStartingPlayer(TypeCell.BLACK);
  }

  void drawIt() {
    board.drawIt(); [cite: 44]
    
    // Optionnel : Afficher un petit texte si la partie est finie
    if (gameOver) {
      fill(255);
      textSize(32);
      textAlign(CENTER, CENTER);
      text("PARTIE TERMINÉE", width/2, 40);
    }
  }

  void handleClick(int x, int y) {
    if (gameOver) return; // Bloque les clics si c'est fini

    PVector cellPos = board.getCellCorrespondPos(new PVector(x, y)); [cite: 45]
    int i = int(cellPos.x);
    int j = int(cellPos.y);

    if (i >= 0 && i < nbCellsY && j >= 0 && j < nbCellsX) {
      if (board.cells[i][j] == TypeCell.VALID) {
        println("Coup joué en : (" + i + ", " + j + ") par " + currentTurn); [cite: 46]
        board.updateCells(i, j); [cite: 46]
        board.detectPiecesToFlip(i, j);
        changeTurn();
      }
    }
  }

  void setStartingPlayer(TypeCell player) {
    if (player == TypeCell.BLACK || player == TypeCell.WHITE) {
      currentTurn = player; [cite: 47]
      board.setCurrentPlayer(player); [cite: 47]
      board.refreshValidCells();
    }
  }

  void changeTurn() {
    // 1. Passer à l'autre joueur
    currentTurn = (currentTurn == TypeCell.WHITE) ? TypeCell.BLACK : TypeCell.WHITE; [cite: 48]
    board.setCurrentPlayer(currentTurn);
    board.refreshValidCells(); [cite: 49]

    // 2. Vérifier si le nouveau joueur peut jouer
    if (!board.hasValidMove()) {
      println("Le joueur " + currentTurn + " ne peut pas jouer et passe son tour.");
      
      // On tente de redonner la main au premier joueur
      currentTurn = (currentTurn == TypeCell.WHITE) ? TypeCell.BLACK : TypeCell.WHITE;
      board.setCurrentPlayer(currentTurn);
      board.refreshValidCells();
      
      // 3. Si personne ne peut jouer, c'est la fin
      if (!board.hasValidMove()) {
        gameOver = true;
        println("FIN DE PARTIE : Plus aucun coup possible.");
        determinerGagnant();
      }
    }
    
    if (!gameOver) {
      println("Au tour de : " + currentTurn); [cite: 49]
    }
  }

  void determinerGagnant() {
    int scoreNoir = board.getScore(TypeCell.BLACK);
    int scoreBlanc = board.getScore(TypeCell.WHITE);
    
    println("--- RÉSULTATS ---");
    println("Pions Noirs : " + scoreNoir);
    println("Pions Blancs : " + scoreBlanc);
    
    if (scoreNoir > scoreBlanc) {
      println("VICTOIRE DES NOIRS !");
    } else if (scoreBlanc > scoreNoir) {
      println("VICTOIRE DES BLANCS !");
    } else {
      println("ÉGALITÉ !");
    }
  }
}
