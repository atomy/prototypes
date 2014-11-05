class Vector2D
{
  int x, y;
  
  Vector2D(int x, int y) { 
    this.x = x;
    this.y = y;
  }
  
  Vector2D mult(Vector2D vec) {
    return new Vector2D(vec.x*this.x, vec.y*this.y);
  }
  
  Vector2D mult(int scal) {
    return new Vector2D(scal*this.x, scal*this.y);
  }  
  
  Vector2D add(Vector2D vec) {
    return new Vector2D(vec.x+this.x, vec.y+this.y);
  }
}
