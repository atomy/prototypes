class ColorOrigin {
  Color clr;
  Point p;
  int sizeXY = 30;
  ArrayList<MixPoint> attachedPoints;
  
  ColorOrigin(Color clr, Point p) {
    this.clr = clr;
    this.p = p;
    attachedPoints = new ArrayList<MixPoint>();
  }
  
  void draw() {
    noStroke();
    fill(clr.r, clr.g, clr.b);
    rect(p.x, p.y, sizeXY, sizeXY);
  }
  
  void AttachPoint(MixPoint p) {
    this.attachedPoints.add(p);
  }
  
  boolean CanPointAttach(Point p) {
    if(p.x > this.p.x && p.x < this.p.x + sizeXY && p.y > this.p.y && p.y < this.p.y + sizeXY) {
      return true;
    }
    return false;
  }
}
