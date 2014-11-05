import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sketch_jul20a extends PApplet {



boolean boltStarted = false;
PImage bg;
int x, y;
ArrayList<BoltBranch> branches;

public void setup() {
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

public void draw() {
  if (branches.size() > 0) {
    ArrayList<BoltBranch> roBranches = (ArrayList<BoltBranch>)branches.clone();
    Iterator<BoltBranch> it = roBranches.iterator();
    while (it.hasNext ()) {
      BoltBranch b = it.next();
      b.update();
      b.draw();
    }
  }
}

public void mouseReleased() {
  startBolt(mouseX, 0, 0, 180);
}

public void startBolt(float inX, float inY, int aMin, int aMax) {
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

  public void draw() {
    //    for(PVector v : points) {
    point(this.x, this.y);
    //  }
  }

  public void update() {
    if (hitGround) {
      return;
    } 
    else if (this.c == this.splitAfter) {
      int a = (int)random(45, 135);
      startBolt(this.x, this.y, a-90, a+90);
    } else {
      int cp = bg.get((int)this.x, (int)this.y);
      //println("red: " + red(cp) + " green: " + green(cp) + " blue: " + blue(cp));
      if (red(cp) == 1 && green(cp) == 55 && blue(cp) == 0) {
        hitGround = true;
      }
    }

    points.add(new PVector(this.x, this.y));
    this.c++;
    int a = (int)random(this.aMin, this.aMax);
    this.x += cos(radians(a))*2;
    this.y += sin(radians(a))*0.5f;

    if (this.y > height)
      hitGround = true;
    if (this.x < 0 || this.x > width)
      hitGround = true;
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "sketch_jul20a" });
  }
}
