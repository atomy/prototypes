public class Frame implements Clickable {
  float x, y, w, h;
  boolean bDisabled, deleteMe;
  
  Frame(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    app.registerDraw(this);
    bDisabled = false; 
  }
  
  void draw() {
    strokeWeight(1);
    stroke(0);
    fill(255);
    rectMode(CORNER);
    rect(round(x), round(y), round(w), round(h));
  }
  
  void onClick(float x, float y) {
    println("Frame::onClick()");
  }
  
  float getX() {
    return this.x;
  }
  
  float getY() {
    return this.y;
  }
  
  float getW() {
    return this.w;
  }
  
  float getH() {
    return this.h;
  }
}
