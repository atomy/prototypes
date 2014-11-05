class MountPoint extends Entity
{
  Paternoster patern;
  PVector pos;
  float lastTick;
  Mounter mount;

  MountPoint(Paternoster p, float x, float y, float z) {
    this.patern = p;
    pos = new PVector(x, y, z);
    this.velo.x = 0;
    this.velo.y = 0;
    lastTick = millis();
  }

  void draw() {
    fill(0, 255, 0);
    noStroke();
    ellipse(pos.x, pos.y, 20, 20);
  }

  void tick(float delta) {
    super.tick(delta);    
    if(millis() - lastTick <= 10)
      return;    
    lastTick = millis();
    pos = patern.p1.GetNextPoint(pos);
    if(attachedEntity == null && mount != null) {
      AttachEntityInRange();
    } else if(attachedEntity != null) {
      attachedEntity.pos.x = pos.x-25;
      attachedEntity.pos.y = pos.y-25;
      attachedEntity.pos.z = pos.z;
      attachedEntity.doesNotBlock = true;
      attachedEntity.velo.x = 0;
      attachedEntity.velo.y = 0;
      attachedEntity.attachedTo = this;
    }
  }
  
  void AttachEntityInRange() {
    for(Entity ent : mEntities) {
      if(ent == this)
        continue;
      if((ent instanceof Wuerfel && mount instanceof RectMounter)
       || ent instanceof Kugel && mount instanceof KugelMounter) {
        if(ent.attachedTo != null)
          continue;
        if(!IsValidPickUpEnt(ent))
          continue;        
        if(dist(ent.pos.x, ent.pos.y, pos.x, pos.y) < 100) {
          //println("AttachEntityInRange() attached ent!");
          attachedEntity = ent;
          audio_object_connect.rewind();
          audio_object_connect.play();
        }
      }
    }
  }
  
  boolean IsValidPickUpEnt(Entity ent) {
    if(ent.groundEntity instanceof Laufband) {
      Laufband b = (Laufband)ent.groundEntity;
      if(b.stop != null)
        return true;
    }
    return false;
  }
}

