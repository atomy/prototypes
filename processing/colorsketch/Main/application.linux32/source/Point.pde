class Point {
  int x, y;
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  boolean Equals(Point p) {
    if(abs(p.x-this.x) <= 2 && abs(p.y-this.y) <= 2)
      return true;
    return false;
  }
  
  boolean Touches(Point p) {
    if (dist(p.x, p.y, this.x, this.y) < minDistance) {
      minDistance = dist(p.x, p.y, this.x, this.y);
    }
    
    if(dist(p.x, p.y, this.x, this.y) <= 5) {
      if (enableDebug) {
        println("touching @ " + p.toString() + " -- " + this.toString() + " with distance: " + dist(p.x, p.y, this.x, this.y));
      }
      
      return true;
    }      
    
    return false;
  }  
  
  boolean IsNearPoint(Point p) {
    if(abs(p.x-this.x) <= 2 && abs(p.y-this.y) <= 2)
      return true;
    return false;    
  }
  
  void draw() {
    strokeWeight(10);
    stroke(0);
    point(x, y);
  }
  
  String toString() {
    return x + ":" + y;
  }
}
