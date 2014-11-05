class Entity {
  PVector pos;
  PVector velo;
  PVector size;
  Entity groundEntity;
  boolean doesNotBlock;
  Entity attachedEntity;
  Entity attachedTo;
  boolean markAsDeleted;
  
  Entity() {
    doesNotBlock = false;
    mEntities.add(this);
    pos = new PVector(0,0);
    velo = new PVector(0, 1.0f);
    size = new PVector(1, 1);
  }
  
  BoundingBox GetBoundingBox() {
    return new BoundingBox(pos, new PVector(1,1));
  }  
  
  void tick(float delta) {
//    println("Entity::tick()");
    if(groundEntity != null) {
      velo = groundEntity.GetConnectedEntVelo();
    }
    
    if(velo.x == 0 && velo.y == 0)
      return;
      
    // deny movement if we are going down and already have a groundEntity assigned
    if(velo.y > 0 && groundEntity != null) {
      return;
    }
    
    Entity blockingEnt = GetEntityAt(pos.x+size.x+velo.x, pos.y+size.y+velo.y);
    if(blockingEnt == null) {
      pos.x += velo.x;
      pos.y += velo.y;
    } else {
      if(groundEntity == null)
        groundEntity = blockingEnt;
      //println("Entity::tick() holy shit someone is at x: '" + (pos.x+velo.x+velo.y) + "' y: '" + (pos.y+velo.y+velo.y) + "'");
    }
  }
  
  PVector GetConnectedEntVelo() {
    PVector p = new PVector();
    p.x = p.y = 0.0f;
    return p;
  }
}
