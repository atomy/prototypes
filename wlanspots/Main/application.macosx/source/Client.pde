class Client {
  float x, y;
  boolean markForRemoval = false;
  
  Client(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void draw() {
    fill(255,0,0);
    stroke(125, 200, 0);
    strokeWeight(4);
    ellipseMode(CENTER);
    ellipse(x, y, 20, 20);
  }
}
