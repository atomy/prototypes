class ColorLine extends Node {
  ArrayList<Point> content = new ArrayList<Point>();
  boolean deleteMe;
  float flow;
  float maxFlow; // only matters for the first line after the origin
  float defaultFlow = 1.0;
  
  ColorLine() {
    Reset();
  }
  
  void Reset() {
    flow = defaultFlow;
    maxFlow = defaultFlow;    
  }
  
  void AddPoint(int x, int y) {
    content.add(new Point(x, y));
  }
  
  void AddPoint(Point p) {
    content.add(p);
  }
  
  void draw() {
    strokeWeight(flow);
    noFill();
    stroke(clr);
    beginShape();
    
    for(Point p : content) {
      vertex(p.x, p.y);
    }
    endShape();
    
    if(enableDebug)
      drawDebug();
  } 
   
  void drawDebug() {
    Point mid = content.get(content.size() / 2);
    stroke(255);
    fill(0);
    textFont(dbgFont);
    int x = mid.x+10;
    int y = mid.y;
    text("ref: " + this.toString(), x, y);
    y+=10;
    text("flow: " + this.flow, x, y);
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
   
  ColorLine copy() {
    ColorLine newLine = new ColorLine();
    newLine.content = (ArrayList<Point>)content.clone();
    newLine.deleteMe = deleteMe;
    newLine.nextNodes = (ArrayList<Node>)nextNodes.clone();
    newLine.prevNodes = (ArrayList<Node>)prevNodes.clone();
    newLine.clr = clr;
    return newLine;
  }
}
