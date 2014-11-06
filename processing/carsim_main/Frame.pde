public class Frame {
  int w, h;
  PVector offset = new PVector(0,0);
  PVector pos = new PVector(0,0);
  boolean bDisabled, deleteMe;
  boolean debug = true;
  
  Frame(float x, float y, int w, int h) {
    pos.x = x;
    pos.y = y;
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
    rect(round(pos.x), round(pos.y), round(w), round(h));
  }
  
  void debugDraw() {
    if (debug) {
      fill(0);
      text("x: " + pos.x + " y: " + pos.y, pos.x, pos.y);
    }
  }
  
  float getX() {
    return pos.x;
  }
  
  float getY() {
    return pos.y;
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
    return pos;
  }
  
  boolean isWithin(PVector in) {
    if (in.x >= getReal().x && in.y >= getReal().y && in.x <= getReal().x+w && in.y <= getReal().y+h) {
      return true;
    }
    return false;
  }
  
  PVector getReal() {
    return PVector.add(offset, pos);
  }
}
