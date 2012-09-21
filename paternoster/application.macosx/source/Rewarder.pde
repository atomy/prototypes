class Rewarder extends Entity implements Drawable
{
  float lastTick;
  
  Rewarder(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    lastTick = millis();
  }
  
  boolean IsMarkedAsDeleted() {
    return markAsDeleted;
  }
  
  void draw() {
    noStroke();
    fill(0, 200, 0);
    rect(pos.x, pos.y, 10, 50);
  }
  
  void tick(float delta) {
    if(millis() - lastTick <= 100) {
      return;
    }
    RewardObjectsInRange(100);
  }
  
  void RewardObjectsInRange(float range) {
    for(Entity ent: mEntities) {
      if(ent == this)
        continue;
      if(ent.markAsDeleted)
        continue;
      if(dist(ent.pos.x, ent.pos.y, pos.x, pos.y) <= range) {
        RewardObject(ent);
      }      
    }
  }
  
  void RewardObject(Entity ent) {
    audio_reward.rewind();
    audio_reward.play();
    if(ent instanceof Wuerfel) {
      stats_money += 30;
    }
    else if(ent instanceof Kugel) {
      stats_money += 40;
    } 
    RemoveEntity(ent);   
  }
}
