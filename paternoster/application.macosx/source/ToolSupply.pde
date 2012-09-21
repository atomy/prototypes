class ToolSupply extends Entity implements Drawable {
  ToolSupply(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.velo.x = 0;
    this.velo.y = 0;
  }
  
  void draw() {
    stroke(100);
    fill(200);
    rect(pos.x, pos.y, 20, 20);
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
}
