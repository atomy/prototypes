class Vector2 {
  float x, y;
  
  Vector2(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Vector2(Vector2 v) {
    this.x = v.x;
    this.y = v.y;
  }
}

interface Clickable {
  void onClick(float x, float y);
  float getX();
  float getY();
  float getW();
  float getH(); 
}
