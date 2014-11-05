class Abspalter extends Entity implements Drawable
{
  float lastTick;
  
  Abspalter(PVector pos) {
    super();
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.doesNotBlock = true;
    this.velo.x = 0;
    this.velo.y = 0;
    this.lastTick = millis();
  }
  
  void draw() {
    fill(255, 0,0);
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-PI/4);
    rect(0,0,10,30);
    popMatrix();
  }
  
  void tick(float delta) {
    super.tick(delta);
    if(millis() - lastTick < 100)
      return;
    CatchBlocksInRange(70);
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }
  
  void CatchBlocksInRange(int range) {
    for(Entity ent : mEntities) {
      if(ent == this)
        continue;
      if(ent instanceof Wuerfel || ent instanceof Kugel || ent instanceof Mounter) {
        if(ent.attachedTo == null) {
          if(ent instanceof Wuerfel || ent instanceof Kugel)
            continue;
        }
        if(dist(ent.pos.x, ent.pos.y, pos.x, pos.y) < range) {
      //    MountPoint mp = (MountPoint)ent.attachedTo;
//          if(mp != null) {
  //          RemoveEntity(mp.mount);
    //        mp.mount = null;
//          }
          if(ent instanceof Mounter) {
            Mounter mn = (Mounter) ent;
            mn.mp.mount = null;
            RemoveEntity(ent);
            continue;
          }
          //else
          //  println("Abspalter::CatchBlocksInRange() cant detach mount-tool! (" + ent.attachedTo.toString() + ")");          
          ent.attachedTo.attachedEntity = null;
          ent.attachedTo = null;
          ent.doesNotBlock = false;
          ent.groundEntity = null;
          TeleportToLaufband(ent);
          break;
        }
      }
    }
  }
  
  void TeleportToLaufband(Entity ent) {
    //println("TeleportToLaufband()");
    audio_object_disconnect.rewind();
    audio_object_disconnect.play();
    for(Entity e : mEntities) {
      if(e instanceof Laufband) {
        Laufband lb = (Laufband) e;
        if(lb.stop == null) {
          ent.pos.x = lb.pos.x + 20;
          ent.pos.y = lb.pos.y - 60;  
          ent.velo.y = 1.0;
          break;
        }
      }
    }
  }
}
