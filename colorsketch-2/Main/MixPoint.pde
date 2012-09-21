class MixPoint {
  Color clr;
  MixPoint next;
  MixPoint[] prev;
  Point p;
  
  MixPoint(Point p) {
    prev = new MixPoint[2];
    this.p = p;
  }

  void draw() {
    noFill();
    strokeWeight(1);
    stroke(clr.r, clr.g, clr.b);
    point(p.x, p.y);
  }  
}
