class CHeader extends CGameArea
{
  int x, y, sizeX, sizeY;
  
  CHeader(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
  }
  
  void draw()
  {
    noFill();
    stroke(255,0,0);
    strokeWeight(1);
    rect(x, y, sizeX, sizeY);
  }
  
  void mousePressed() {
    //println("CHeader::mousePressed");
  }
}
