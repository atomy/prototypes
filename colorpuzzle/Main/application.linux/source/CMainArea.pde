class CMainArea extends CGameArea {
  CGrid mGrid;
  CStartPoint mStartPoint;
  
  CMainArea(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
    mGrid = new CGrid(this.x+64, this.y+64, 672, 384);
    mStartPoint = new CStartPoint(this.x+tileSize/2, this.y+tileSize*4);    
  }
    
  void draw() {
    noFill();
    stroke(0,255,0);
    strokeWeight(4);
    rect(x, y, sizeX, sizeY);
    mGrid.draw();
    mStartPoint.draw();        
  }
  
  void mousePressed() {
    //println("CMainArea::mousePressed");
  }
}

class CStartPoint extends CGameArea {  
  CStartPoint(int x, int y) {
    super(x, y, 30, 100);   
  }
  
  void draw() {
    fill(0, 255, 0);
    stroke(200,100,200);
    rect(this.x, this.y, this.sizeX, this.sizeY);
    stroke(255);
    strokeWeight(10);
    noFill();
    line(this.x+tileSize/2, this.y+tileSize*3+tileSize/2, this.x+tileSize/2+tileSize, this.y+tileSize*3+tileSize/2);
    line(this.x+tileSize/2, this.y+tileSize*3+tileSize/2, this.x+tileSize/2, this.y+tileSize*3);
  }
}
