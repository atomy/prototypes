class Paternoster
{
  Zahnrad r1, r2;
  Pfad p1;
  ArrayList<MountPoint> mPoints;
  int dummyTick;
  ArrayList<Laufband> mLaufbaender;  
  
  Paternoster() {
    r1 = new Zahnrad(this, new PVector(420, 110));
    r2 = new Zahnrad(this, new PVector(420, 430));
    mLaufbaender = new ArrayList<Laufband>();
    p1 = new Pfad(this);
    //dummy = p1.GetStartPoint();
    dummyTick = millis();
    mPoints = p1.CreatePointsAlongPath();
    //println("we have '" + mPoints.size() + "' points along the path!");
    Laufband b1 = new Laufband(this, new PVector(10, 400), new PVector(330, 10), true);
    Abspalter a1 = new Abspalter(new PVector(470, 300));
    Laufband b2 = new Laufband(this, new PVector(490, 320), new PVector(300, 10), false);
    b2.speed = 2.0f;
    mDrawables.add(a1);
    mLaufbaender.add(b1);
    mLaufbaender.add(b2);
  }
  
  void draw() {
    noFill();
    stroke(255, 0, 0);
    r1.draw();
    r2.draw();
    p1.draw();
    for(MountPoint mp : mPoints) {
      mp.draw();
    }
    for(Laufband b : mLaufbaender) {
      b.draw();
    }    
    //noStroke();
    //fill(255, 0, 0);
    //ellipse(dummy.x, dummy.y, 50, 50);
  }
  
  void tick(float delta) {
    r1.tick(delta);
    r2.tick(delta);
    if(millis() - dummyTick >= 0) {
      //MoveDummy();
      for(MountPoint mp : mPoints) {
        mp.tick(delta);
      }      
      dummyTick = millis();
    }
  }
  
  /*
  void MoveDummy() {
    PVector next = p1.GetNextPoint(dummy);
    if(next != null)
      dummy = next;
  }
  */
  MountPoint GetNearestMountPoint(PVector p) {    
    for(MountPoint mp : mPoints) {
      if(dist(mp.pos.x, mp.pos.y, p.x, p.y) < 100) {
        return mp;
      }
    }
    return null;
  }
}
