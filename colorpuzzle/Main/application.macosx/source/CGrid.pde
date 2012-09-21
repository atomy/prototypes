static int tileSize = 32;

class CGrid extends CGameArea {
  int rows, cols;
  CGridElement[][] mGrid;  
  
  CGrid(int x, int y, int sizeX, int sizeY) {
    super(x, y, sizeX, sizeY);
    this.cols = sizeX / tileSize;    
    this.rows = sizeY / tileSize;
    this.rows = rows;
    this.cols = cols;
    mGrid = new CGridElement[cols][rows];    
    
    for(int ix = 0; ix < cols; ix++) {     
      for(int iy = 0; iy < rows; iy++) {
        mGrid[ix][iy] = new CGridElement(this, this.x + ix*tileSize, this.y + iy*tileSize);
      }
    }
  }
  
  void draw() {
    for(int x = 0; x < cols; x++) {
      for(int y = 0; y < rows; y++) {
        mGrid[x][y].draw();
      }
    }
    noFill();
    stroke(255,0,0);
    strokeWeight(4);
    rect(this.x, this.y, this.sizeX, this.sizeY);    
  }
  
  // TODO
  boolean SnapToGrid() {
    if(gDragElement != null) {
      for(int ix = 0; ix < cols; ix++) {     
        for(int iy = 0; iy < rows; iy++) {
          CGridElement ele = mGrid[ix][iy];
        }
      }      
    }
    return true;
  }
}
