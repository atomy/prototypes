class Wuerfel extends Entity implements Drawable
{
  
  Wuerfel(Spawner spawn, int size) {
    super();
    this.pos.x = spawn.pos.x;
    this.pos.y = spawn.pos.y;
    this.size.x = size;
    this.size.y = size;
    this.doesNotBlock = false;
  }
  
  void draw() {
    rectMode(CORNER);
    fill(0,200,200);
    stroke(50,50,50);
    pushMatrix();
    translate(pos.x+25, pos.y+25);
    rotate(pos.z);
    rect(-25, -25, size.x, size.y);
    popMatrix();
  }
  
  void tick(float delta) {
    super.tick(delta);
    //println("Wuerfel::tick()");
  }
  
  BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, size);
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
}
