class KugelMounter extends Mounter
{
  KugelMounter(MountPoint point) {
    super(point);
  }
  
  void tick(float delta) {
    super.tick(delta);
  }
  
  void draw() {
    noFill();
    stroke(0);
//    strokeWeight();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(mp.pos.z);
    ellipse(0, 0, 50, 50);
    popMatrix();
  }
}

class RectMounter extends Mounter
{
  RectMounter(MountPoint point) {
    super(point);
  }
  
  void tick(float delta) {
    super.tick(delta);
  }
  
  void draw() {
    noFill();
    stroke(0);
//    strokeWeight();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(mp.pos.z);
    line(25, -25, 25, 25); // A
    line(25, -25, -30, -25); // B
    line(25, 25, -30, 25); // C
    popMatrix();
  }
}

class Mounter extends Entity implements Drawable
{
  MountPoint mp;
  
  Mounter(MountPoint point) {
    super();
    this.mp = point;
    this.velo.x = 0;
    this.velo.y = 0;
    point.mount = this;
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }
  
  void draw() {
  }
  
  void tick(float delta) {
    super.tick(delta);
    this.pos.x = mp.pos.x;
    this.pos.y = mp.pos.y;
  }
}
