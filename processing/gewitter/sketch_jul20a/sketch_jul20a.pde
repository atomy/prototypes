import processing.opengl.*;

boolean boltStarted = false;
PImage bg;
int x, y;
ArrayList<BoltBranch> branches;

void setup() {
  size(640, 400, OPENGL);
  frameRate(300);
  bg = loadImage("img/bg.png");
  branches = new ArrayList<BoltBranch>();
  background(bg);
  smooth();
  x = 200;
  y = 0;
  stroke(100);
  strokeWeight(2);
}

void draw() {
  if (branches.size() > 0) {
    ArrayList<BoltBranch> roBranches = (ArrayList<BoltBranch>)branches.clone();

    for (int i = 0; i < roBranches.size(); i++) {
      BoltBranch b = (BoltBranch)roBranches.get(i);
      b.update();
      b.draw();
    }
  }
}

void mouseReleased() {
  startBolt(mouseX, 0, 0, 180);
}

void startBolt(float inX, float inY, int aMin, int aMax) {
  branches.add(new BoltBranch(inX, inY, aMin, aMax));
}

class BoltBranch {
  ArrayList<PVector> points;
  float x, y;
  int c;
  boolean hitGround = false;
  int aMin, aMax;
  int splitAfter;

  BoltBranch(float x, float y, int aMin, int aMax) {
    this.x = x;
    this.y = y;
    this.c = 0;
    this.aMin = aMin;
    this.aMax = aMax;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
    this.splitAfter = (int)random(20, 300);
  }

  void draw() {
    //    for(PVector v : points) {
    point(this.x, this.y);
    //  }
  }

  void update() {
    if (hitGround) {
      return;
    } 
    else if (this.c == this.splitAfter) {
      int a = (int)random(45, 135);
      startBolt(this.x, this.y, a-90, a+90);
    } else {
      color cp = bg.get((int)this.x, (int)this.y);
      //println("red: " + red(cp) + " green: " + green(cp) + " blue: " + blue(cp));
      if (red(cp) == 1 && green(cp) == 55 && blue(cp) == 0) {
        hitGround = true;
      }
    }

    points.add(new PVector(this.x, this.y));
    this.c++;
    int a = (int)random(this.aMin, this.aMax);
    this.x += cos(radians(a))*2;
    this.y += sin(radians(a))*0.5;

    if (this.y > height)
      hitGround = true;
    if (this.x < 0 || this.x > width)
      hitGround = true;
  }
}

