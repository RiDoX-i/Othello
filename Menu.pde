// this class is responsible for creating the buttons at the bottom of the window
// and handling button clicks: Restart, Return (undo), Mode toggle (PvP / PvAI), Quit

enum GameStatus {
  PVP,
  PVAI
}

class Menu {

  Game game;
  GameStatus gameStatus;
  int returnStat = 0; // 1 if we clicked return at the current turn 0 if not

  // button geometry – bottom strip of the window
  final int BTN_Y      = 760;
  final int BTN_H      = 44;
  final int BTN_RADIUS = 10;

  final int BTN_RESTART_X = 120;  final int BTN_RESTART_W = 160;
  final int BTN_RETURN_X  = 310;  final int BTN_RETURN_W  = 160;
  final int BTN_MODE_X    = 500;  final int BTN_MODE_W    = 160;
  final int BTN_QUIT_X    = 690;  final int BTN_QUIT_W    = 130;

  // hover state
  boolean hoverRestart = false;
  boolean hoverReturn  = false;
  boolean hoverMode    = false;
  boolean hoverQuit    = false;

  Menu(Game g) {
    game       = g;
    gameStatus = GameStatus.PVP;
  }

  void drawIt() {
    // background strip
    noStroke();
    fill(15, 15, 15, 220);
    rectMode(CORNER);
    rect(0, 720, width, 80);

    updateHover(mouseX, mouseY);

    drawButton(BTN_RESTART_X, BTN_Y, BTN_RESTART_W, BTN_H, "Restart",   hoverRestart, color(40, 160, 80));
    drawButton(BTN_RETURN_X,  BTN_Y, BTN_RETURN_W,  BTN_H, "Return",    hoverReturn,  color(70, 110, 200));
    drawButton(BTN_MODE_X,    BTN_Y, BTN_MODE_W,    BTN_H, modeLabel(), hoverMode,    color(180, 130, 20));
    drawButton(BTN_QUIT_X,    BTN_Y, BTN_QUIT_W,    BTN_H, "Quit",      hoverQuit,    color(180, 40, 40));
  }

  void drawButton(int cx, int cy, int bw, int bh, String label, boolean hover, color baseCol) {
    rectMode(CENTER);
    if (hover) {
      fill(red(baseCol) + 40, green(baseCol) + 40, blue(baseCol) + 40);
      stroke(255, 255, 255, 180);
      strokeWeight(2);
    } else {
      fill(baseCol);
      stroke(255, 255, 255, 60);
      strokeWeight(1);
    }
    rect(cx, cy, bw, bh, BTN_RADIUS);

    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(label, cx, cy);
  }

  String modeLabel() {
    return (gameStatus == GameStatus.PVP) ? "Mode: PvP" : "Mode: PvAI";
  }

  void updateHover(int x, int y) {
    hoverRestart = isOver(x, y, BTN_RESTART_X, BTN_Y, BTN_RESTART_W, BTN_H);
    hoverReturn  = isOver(x, y, BTN_RETURN_X,  BTN_Y, BTN_RETURN_W,  BTN_H);
    hoverMode    = isOver(x, y, BTN_MODE_X,    BTN_Y, BTN_MODE_W,    BTN_H);
    hoverQuit    = isOver(x, y, BTN_QUIT_X,    BTN_Y, BTN_QUIT_W,    BTN_H);
  }

  boolean isOver(int mx, int my, int cx, int cy, int bw, int bh) {
    return (mx >= cx - bw/2 && mx <= cx + bw/2 &&
            my >= cy - bh/2 && my <= cy + bh/2);
  }

  void handleClick(int x, int y) {

    // RESTART – setBoard() resets all cells and places the 4 starting pieces
    if (isOver(x, y, BTN_RESTART_X, BTN_Y, BTN_RESTART_W, BTN_H)) {
      game.restart();
      return;
    }

    // RETURN – revokeLastMove() to be implemented by the Board teammate
    if (isOver(x, y, BTN_RETURN_X, BTN_Y, BTN_RETURN_W, BTN_H)) {
      game.board.loadsave(); // load n-1 board
      game.board.refreshValidCells();
      if (returnStat == 1){
        game.changeTurn(); // give back the turn
        returnStat = 0;
      }
      return;
    }

    // MODE TOGGLE
    if (isOver(x, y, BTN_MODE_X, BTN_Y, BTN_MODE_W, BTN_H)) {
      if (gameStatus == GameStatus.PVP) {
        gameStatus = GameStatus.PVAI;
        game.board.refreshValidCells();
      } else {
        gameStatus = GameStatus.PVP;
      }
      game.board.setBoard(game.board.cells,game.board.save);
      game.board.refreshValidCells();

      return;
    }

    // QUIT
    if (isOver(x, y, BTN_QUIT_X, BTN_Y, BTN_QUIT_W, BTN_H)) {
      exit();
      return;
    }
  }
}