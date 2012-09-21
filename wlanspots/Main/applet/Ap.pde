static int AP_RADIUS = 100;
static int AP_ANIM_TIME = 100;

class Ap {
  boolean attached = true;
  int x, y;
  float animState = 0;
  long nextAnimTime = 0;
  
  void draw() {
    noFill();
    strokeWeight(4);
    stroke(200, 200, 200);
    ellipseMode(CENTER);
    if(attached)
      ellipse(mouseX, mouseY, AP_RADIUS, AP_RADIUS);
    else
      ellipse(x, y, AP_RADIUS, AP_RADIUS);
      
    if(!attached && nextAnimTime < millis()) {
      nextAnimTime = AP_ANIM_TIME + millis();
      animState+=0.1;
      strokeWeight(1);
      int rad = constrain((int)animState, 0,(int) AP_RADIUS);
      ellipse(x, y, rad, rad);
      if(animState >= 1.0)
        animState = 0.0;
    }
  }
  
  void deploy() {
    this.x = mouseX;
    this.y = mouseY;
    this.attached = false;
    catchClients();
  }
  
  void catchClients() {
    for(Client c : f.clients) {
      if(dist(c.x, c.y, this.x, this.y) < AP_RADIUS/2) {
        c.markForRemoval = true;       
        //println("catchClients() dist is: " + dist(c.x, c.y, this.x, this.y));
      }
    }
  }
}
