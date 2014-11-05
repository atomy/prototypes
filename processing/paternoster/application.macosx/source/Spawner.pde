class Spawner extends Entity implements Drawable
{
  boolean spawned = false;
  float lastTick;
  
  Spawner(PVector pos, int size) {
    super();
    this.pos = pos;
    this.size.x = size;
    this.size.y = size;
    this.doesNotBlock = true;
    this.velo.x = 0;
    this.velo.y = 0;
    this.lastTick = millis();
  }
  
  void draw() {
    stroke(255,0,0);
    fill(100,100,0);
    rect(pos.x, pos.y, size.x, size.y);
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }  
  
  void tick(float delta) {
    if(millis() - lastTick <= 500)
      return;
    lastTick = millis();
    super.tick(delta);
    if(!IsSpawnBlocked()/* && mousePressed && mouseButton == RIGHT*/) {
      Drawable obj;
      if(random(0,2) <= 1.0f)
        obj = new Kugel(this, 50);
      else {
        obj = new Wuerfel(this, 50);
      }
      mDrawables.add(obj);
      spawned = true;
    }    
  }
  
  boolean IsSpawnBlocked() {
    if(GetEntityAt(pos.x, pos.y) == null && GetEntityAt(pos.x+50, pos.y) == null && GetEntityAt(pos.x, pos.y+50) == null && GetEntityAt(pos.x+50, pos.y+50) == null)
      return false;
    return true;
  }
}
