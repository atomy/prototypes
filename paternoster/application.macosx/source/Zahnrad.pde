class Zahnrad
{
  PVector pos;
  Paternoster patern;
  float angle;
  float lastTick;
  
  Zahnrad(Paternoster p, PVector pos) {
    this.patern = p;
    this.pos = pos;
    this.angle = 0.2f;
    this.lastTick = millis();
  }
  
  void draw() {
    noStroke();
    rectMode(CENTER);
    noFill();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(this.angle);
    // image
    fill(255, 0, 0);
    rect(0, 0, 50, 50);
    popMatrix();
  }
  
  void tick(float delta) {
    if(millis() < lastTick + 10.0f)
      return;
    lastTick = millis();
    this.angle += PI/64;
    
    if(abs(this.angle) >= PI)
      this.angle = 0.0f;
  }
}
