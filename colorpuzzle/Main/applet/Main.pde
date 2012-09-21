CGame gGame;
CElementSelection gElementSelection;
CGameElement gDragElement;

void setup()
{
  size(800,700);
  smooth();
  background(0);
  gGame = new CGame();
  gDragElement = null;
}

void draw()
{
  background(0);
  gGame.draw();
}

void mousePressed()
{
  gGame.mousePressed();
}

void mouseMoved() {
  if(gDragElement != null) {
    gDragElement.x = mouseX;
    gDragElement.y = mouseY;
  }
}

void keyReleased()
{
  
}

void tick()
{
  
}

class CGameArea {
  int x, y, sizeX, sizeY;
  
  CGameArea(int x, int y, int sizeX, int sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;    
  }
  
  void draw() {
  }
  
  void mousePressed() {
  }
}

boolean IsPointInElementsArea(CGameArea area, int x, int y) {
    if(x > area.x && x < area.x+area.sizeX) {
      if(y > area.y && y < area.y+area.sizeY) {       
        return true;
      }
    }
    return false;
}
