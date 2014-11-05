class Kugel extends Entity implements Drawable
{
  
  Kugel(Spawner spawn, int size) {
    super();
    this.pos.x = spawn.pos.x;
    this.pos.y = spawn.pos.y;
    this.size.x = size;
    this.size.y = size;
    this.doesNotBlock = false;
  }
  
  void draw() {
    rectMode(CORNER);
    fill(200,100, 200);
    stroke(50,50,50);
    pushMatrix();
    translate(pos.x+25, pos.y+25);
    rotate(pos.z);
    ellipse(0, 0, size.x, size.y);
    popMatrix();
  }
  
  void tick(float delta) {
    super.tick(delta);
  }
  
  BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, size);
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
}
