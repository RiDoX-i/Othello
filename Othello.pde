// this class is responsible for launching the game by :
// creating the window and calling the draw function of the Game class

Game game;

void setup() {
  size(800, 800);
  game = new Game();
}

void draw() {
  if (game != null) {
    game.drawIt();
  }
}

void mousePressed() {
  if (game != null) {
    game.handleClick(mouseX, mouseY);
  }
}
