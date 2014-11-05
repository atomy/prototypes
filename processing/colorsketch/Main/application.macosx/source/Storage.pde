class Storage extends Node {
  Point p;
  float fillprt;
  color clr = color(100,100,0);
  int sizeX = 100;
  int sizeY = 40;
  int safeDistance = 10;  
  
  Storage(Point p) {
    this.p = p;
    fillprt = 0.0f; // 0.0%
  }
  
  void draw() {
    noStroke();
    fill(clr);
    rect(this.p.x, this.p.y, this.sizeX, this.sizeY);
    
    if(enableDebug)
      drawDebug();
  }
  
  void drawDebug() {
    Point mid = p;
    stroke(clr);
    fill(clr);
    textFont(dbgFont);
    int x = mid.x+sizeX+10;
    int y = mid.y;
    text("ref: " + this.toString(), x, y);
    y+=10;
    for(Node n : prevNodes) {
      text("prev: " + n.toString(), x, y);
      y+=10;      
    }
    for(Node n : nextNodes) {
      text("next: " + n.toString(), x, y);
      y+=10;
    }     
  }
  
  void AddLine(ColorLine clrLine) {
    prevNodes.add(clrLine);
  }
  
  boolean CanPointAttach(Point p) {
    if(p.x > this.p.x - safeDistance && p.x < this.p.x + sizeX + safeDistance && p.y > this.p.y - safeDistance && p.y < this.p.y + sizeY + safeDistance)
      return true;
    return false;    
  }  
}
