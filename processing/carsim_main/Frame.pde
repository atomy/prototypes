public class Frame {
  float x, y;
  int w, h;
  PVector offset = new PVector(0,0);
  boolean bDisabled, deleteMe;
  boolean debug = true;
  
  Frame(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    app.registerDraw(this);
    bDisabled = false; 
  }
  
  void setOffset(PVector in) {
    offset = in;
  }
  
  void draw() {
    strokeWeight(1);
    stroke(0);
    fill(255);
    rectMode(CORNER);
    rect(round(x), round(y), round(w), round(h));
  }
  
  void debugDraw() {
    if (debug) {
      fill(0);
      text("x: " + x + " y: " + y, x, y);
    }
  }
  
  float getX() {
    return this.x;
  }
  
  float getY() {
    return this.y;
  }
  
  int getW() {
    return this.w;
  }
  
  int getH() {
    return this.h;
  }
  
  float absTo(int x, int y) {
    PVector cur = getVector();
    
    return PVector.dist(cur, new PVector(x, y));
  }
  
  PVector getVector() {
    return new PVector(x, y);
  }
  
  boolean isWithin(PVector in) {
    if (in.x >= x-offset.x && in.y >= y-offset.y && in.x <= x-offset.x+w && in.y <= y-offset.y+h) {
      return true;
    }
    return false;
  }
}
