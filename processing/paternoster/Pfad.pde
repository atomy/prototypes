class Pfad
{
  ArrayList<PVector> points; // z is angle
  Paternoster patern;
  
  Pfad(Paternoster p) {
    this.patern = p;
    points = new ArrayList<PVector>();
    Create();
  }
  
  void Create() {
    for(float x = PI; x <= PI*2; x+=PI/64) {
      points.add(new PVector(420+cos(x)*40, 100+sin(x)*40, x+PI));
    }
    for(int i = 100; i <= 450; i +=2) {
      points.add(new PVector(460, i, PI));
    }     
    for(float x = 0; x <= PI; x+=PI/64) {
      points.add(new PVector(420+cos(x)*40, 450+sin(x)*40, x+PI));
    }
    for(int i = 450; i >= 100; i-=2) {
      points.add(new PVector(380, i, 0));
    }
  }
  
  void draw() {
    noStroke();
    fill(0,0,255);
    for(PVector v : points) {
      rect(v.x, v.y, 10, 10);
    }
  }
  
  void DumpPoints() {
    //println("DumpPoints() points are: ");
    for(int i = 0; i < 100; i++) {
      println("[" + i + "]" + "x: " + points.get(i).x + " y: " + points.get(i).y);
    }        
  }
  
  ArrayList<MountPoint> CreatePointsAlongPath() {    
    ArrayList<MountPoint> mPoints = new ArrayList<MountPoint>();
    int i = 1;
    for(PVector v : points) {      
      if(i >= 50) {
        mPoints.add(new MountPoint(this.patern, v.x, v.y, v.z));
        i = 1;
      }
      i++;
    }
    return mPoints;
  }
  
  PVector GetStartPoint() {
    //println("GetStartPoint() returning x: " + points.get(0).x + " y: " + points.get(0).y);
    return new PVector(points.get(0).x, points.get(0).y);
  }
  
  PVector GetNextPoint(PVector d) {
    //println("GetNextPoint() asking for next point using x: " + d.x + " y: " + d.y);
    PVector p = null;
    boolean next = false;
    for(PVector v : points) {
      if(next) {
        if(d.x == v.x && d.y == v.y)
          continue;
        p = new PVector(v.x, v.y, v.z);
        //println("GetNextPoint() next flag set, bailing out...");
        break;
      }
      if(d.x == v.x && d.y == v.y) {
        //println("GetNextPoint() search point found, setting next flag...");
        next = true;
      }
    }
    if(p == null) {      
      p = GetStartPoint();
      //println("GetNextPoint() point is null, returning startpoint - x: " + p.x + " y: " + p.y);
    }
      
    //println("GetNextPoint() returning x: " + p.x + " y: " + p.y);
    return p;
  }
}
