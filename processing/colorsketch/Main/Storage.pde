class Storage extends Node {
  ArrayList<String> debugTexts = new ArrayList<String>();
  Point p;
  float flow;
  color clr = color(255,255,255);
  int sizeX = 200;
  int sizeY = 40;
  int safeDistance = 10;
  
  Storage() {
    this.p = new Point(width/2 - sizeX/2, height - sizeY - 20);
  }
  
  void draw() {
    stroke(0);
    strokeWeight(2);
    fill(clr);
    rect(this.p.x, this.p.y, this.sizeX, this.sizeY);
    
    if(enableDebug) {
      drawDebug();
    }
  }
  
  void addDebugText(String text) {
    debugTexts.add(text);
  }
  
  void drawDebug() {
    int x = p.x+sizeX+10;
    int y = p.y;
    textFont(dbgFont);
    stroke(255);
    fill(255);        
    text("ref" + this, x, y);   
    y += 10;
    text("flow: " + this.flow, x, y);
    y += 10;
    
    for (String debugText : debugTexts) {
      text(debugText, x, y);
      y += 10;
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
  
  void calcAndApplyColor() {
    println("recalculate color for node network");
    float calcFlow = 0;
   
    for(Node prevNode : prevNodes) {
      ColorLine prevColorLine = (ColorLine) prevNode;
      clr = blendColors(prevColorLine.clr, clr, prevColorLine.flow, calcFlow);
      calcFlow += prevColorLine.flow;
    }
    
    flow = calcFlow;
  }
}
