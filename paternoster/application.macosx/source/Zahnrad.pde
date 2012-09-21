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
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(this.angle);  
    image(img_zahnrad, -52, -52,104, 104);
    popMatrix();    
  }
  
  void tick(float delta) {
    if(millis() < lastTick + 10.0f)
      return;
    lastTick = millis();
    this.angle += PI/64;
    
    if(abs(this.angle) >= PI*2)
      this.angle = 0.0f;
  }
}
