class CGridElement extends CGameArea {
  CGrid grid;
  
  CGridElement(CGrid g, int x, int y) {
    super(x, y, tileSize, tileSize);
    this.grid = g;
  }
  
  void draw() {
    fill(100);
    stroke(0,0,255);
    strokeWeight(2);
    rect(this.x, this.y, tileSize, tileSize);
  }
}
