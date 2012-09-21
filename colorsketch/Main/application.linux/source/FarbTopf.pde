class FarbTopf extends Node {
  Point p;
  int sizeXY = 30;
  int safeDistance = 10;
  
  FarbTopf(color clr, Point p) {
    this.clr = clr;
    this.p = p;
  }
  
  void AddLine(ColorLine line) {
    nextNodes.add(line);
  }
  
  void draw() {
    noStroke();
    fill(clr);
    rect(p.x, p.y, sizeXY, sizeXY);
    
    if(enableDebug)
      drawDebug();
  }
  
  void drawDebug() {
    Point mid = p;
    stroke(clr);
    fill(clr);
    textFont(dbgFont);
    int x = mid.x+sizeXY+10;
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
  
  boolean IsPointColliding(Point p) {
    if(p.x > this.p.x && p.x < this.p.x + sizeXY && p.y > this.p.y && p.y < this.p.y + sizeXY)
      return true;
    return false;
  }  
  
  boolean CanPointAttach(Point p) {
    if(p.x > this.p.x - safeDistance && p.x < this.p.x + sizeXY + safeDistance && p.y > this.p.y - safeDistance && p.y < this.p.y + sizeXY + safeDistance)
      return true;
    return false;    
  }
}
