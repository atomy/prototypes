class CGameElement extends CGameArea {
  CGrid g;
  ArrayList<Vector2D> inout;
  int flowRate;  
  
  CGameElement(int x, int y) {
    super(x, y, tileSize, tileSize);
    inout = new ArrayList<Vector2D>();
    this.flowRate = 10;
  }
  
  void SetFlowRate(int rate) {
    this.flowRate = rate;
  }
  
  void SetBounds(int x, int y, int sizeX, int sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;    
  }
  
  void draw() {
    if(this.x < 0 || this.y < 0)
      return;
    fill(100);
    stroke(0,0,255);
    strokeWeight(2);
    if(sizeX <= 0 || sizeY <= 0)
      rect(x, y, tileSize, tileSize);
    else
      rect(x, y, this.sizeX, this.sizeY);

    noStroke();
    fill(255);
    int midX = this.x+this.sizeX/2;
    int midY = this.y+this.sizeY/2;
    int midPointSizeX = this.sizeX/8*this.flowRate;
    int midPointSizeY = this.sizeY/8*this.flowRate;
    //rect(midX-midPointSizeX/2, midY-midPointSizeY/2, midPointSizeX, midPointSizeY);
    
    for(Vector2D vecInOut : inout) {
      Vector2D vecDefaultSize = new Vector2D(midPointSizeX,midPointSizeY);
      Vector2D vecToDraw = vecInOut.mult(this.sizeX/2);
      strokeWeight(this.flowRate);
      stroke(255);
      line(midX, midY, midX+vecToDraw.x, midY+vecToDraw.y);
      //println("line("+midX+", "+midY+", "+(midX+vecToDraw.x)+", "+(midY+vecToDraw.y)+")");
    }
  }
  
  void mousePressed() {
    if(gDragElement == null) {
      gDragElement = this.copy();
      gGame.mDrawables.add(gDragElement);
    }
  }
  
  CGameElement copy() {
    return null;
  }
}
