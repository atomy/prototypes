class Laufband extends Entity
{
  Paternoster patern;
  Stopper stop;
  float speed;
  
  Laufband(Paternoster patern, PVector pos, PVector size, boolean doBlocker) {
    super();
    this.pos = pos;
    this.size = size;
    this.patern = patern;
    speed = 1.0f;
  
    if(doBlocker)
      this.stop = new Stopper(this);
  }
  
  void draw() {
    rectMode(CORNER);
    noStroke();
    noFill();
    stroke(100, 100, 100);
    fill(200, 0, 0);
    rect(pos.x, pos.y, size.x, size.y);
    if(stop != null)
      stop.draw();
  }
  
  void tick(float delta) {
  }
  
  BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, size);
  }  
  PVector GetConnectedEntVelo() {
    PVector p = new PVector();
    p.x = speed;
    p.y = 0.0f;
    return p;
  }  
}

class Stopper extends Entity {
  Stopper(Laufband b) {
    super();
    this.size.x = 10;
    this.size.y = 30;
    this.pos.x = b.pos.x;
    this.pos.y = b.pos.y;
    this.pos.x += b.size.x;
    this.pos.y -= 20;
    this.velo.x = 0;
    this.velo.y = 0;
  }
  
  void draw() {
    stroke(50, 150, 0);
    fill(200, 0, 200);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }
}
