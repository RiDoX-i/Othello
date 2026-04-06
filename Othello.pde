// Othello.pde  –  entry point
// Creates the window, owns the Game and Menu objects,
// and routes Processing callbacks to them.

Game game;
  

void setup() {
  size(800, 800);
  game = new Game();
  game.menu = new Menu(game);   // Menu receives a reference to Game
}

void draw() {
  if (game != null) {
    game.drawIt();
  }
    game.menu.drawIt();    // draws the button strip on top of the board
  
}

void mousePressed() {
  if (game != null) {
    game.handleClick(mouseX, mouseY);
    game.menu.handleClick(mouseX, mouseY);
  }
}